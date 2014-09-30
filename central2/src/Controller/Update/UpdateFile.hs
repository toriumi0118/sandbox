module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Applicative
import Control.Monad (forM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Char (toLower)
import Data.Foldable (toList)
import Data.List (isInfixOf, partition)
import Data.Maybe (catMaybes, isJust, fromJust)
import System.Directory (doesFileExist, doesDirectoryExist, getDirectoryContents)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, UpdateContent(UpdateOfficeFile, UpdatePdfDoc), FileType(..), HistoryId, store)
import Controller.Update.HistoryContext (History(History, FileHistory, DirHistory), FileAction(DELETE, UPDATE), order, targetId, action, filename)

createUpdateContent
    :: FileType -> FilePath -> History -> Maybe (HistoryId, UpdateContent)
createUpdateContent PRESENTATION _ (History hid i DELETE) = Just
    (hid, UpdateOfficeFile "" PRESENTATION DELETE (fromIntegral i) "presentation")
createUpdateContent PRESENTATION _ (History hid i UPDATE) = Just
    (hid, UpdateOfficeFile "" PRESENTATION DELETE (fromIntegral i) "presentation")
createUpdateContent PRESENTATION path (History hid i act) = Just
    (hid, UpdateOfficeFile path PRESENTATION act (fromIntegral i) "presentation")
createUpdateContent PDF_DOC _ (FileHistory hid _ act n) = Just
    (hid, UpdatePdfDoc n PDF_DOC act)
createUpdateContent TOPIC n (DirHistory hid _ act _) = Just
    (hid, UpdatePdfDoc n TOPIC act)
createUpdateContent typ path (FileHistory hid i a n) = Just
    (hid, UpdateOfficeFile n typ a (fromIntegral i) path)
createUpdateContent _ _ _ = Nothing

deleteAction
    :: FileType
    -> [(FilePath, History)]
    -> ([(FilePath, History)], [(HistoryId, UpdateContent)])
deleteAction t = go [] []
  where
    go rs cs [] = (rs, reverse $ catMaybes cs)
    go rs cs ((_, History _ _ _):hs)                   = go rs cs hs
    go rs cs ((path, h@(FileHistory _ _ DELETE _)):hs) =
        go rs (createUpdateContent t path h:cs) hs
    go rs cs (h:hs)                                    = go (h:rs) cs hs

filePath :: FileType -> History -> FilePath
filePath TOPIC = const "data/topic"
filePath PDF_DOC = const "data/pdf"
filePath typ
    = printf ("data/office/office%d/" ++ map toLower (show typ))
    . targetId

data FileOrDirectory = NotExist | File | Directory deriving (Eq)

fileOrDir :: a -> a -> a -> FileOrDirectory -> a
fileOrDir n _ _ NotExist  = n
fileOrDir _ f _ File      = f
fileOrDir _ _ d Directory = d

bool :: a -> a -> Bool -> a
bool t _ True  = t
bool _ f False = f

checkFileOrDirectory
    :: (Functor m, MonadIO m) => FilePath -> m FileOrDirectory
checkFileOrDirectory path = liftIO (doesFileExist path) >>= bool
    (return File) 
    (bool Directory NotExist <$> liftIO (doesDirectoryExist path))

-- TODO?: includePath
recursiveFillupUpdateContent :: (MonadIO m, Applicative m)
    => FileType -> [(FilePath, History)] -> DataProvider m ()
recursiveFillupUpdateContent t fhs = mapM checkFile fhs >>= mapM_ f
  where
    checkFile fh = (,) <$> checkFileOrDirectory (fst fh) <*> return fh
    f (NotExist, (path, _)) = fail $ "Update file not found: " ++ path
    f (File, (path, h)) = if "gitkeeper" `isInfixOf` path
        then return ()
        else store $ toList $ createUpdateContent t path h
    f (Directory, (path, h)) = do
        cs <- liftIO $ getDirectoryContents path
        mapM_ (\c -> checkFile (c, h) >>= f) cs

updatedFile :: (Applicative m, MonadIO m) => FileType -> DataProvider m ()
updatedFile t@PRESENTATION = do
    fhs <- map ((,) <$> filePath t <*> id) <$> getHistories
    let (hs, uc) = deleteAction t fhs
    store uc
    store
        $ catMaybes
        $ map (uncurry $ createUpdateContent t)
        $ filter isUpdate hs
    recursiveFillupUpdateContent t fhs
  where
    isUpdate (_, h) = action h == UPDATE
updatedFile t@TOPIC = do
    (hs, dels) <- partition ((== DELETE) . action)
        . filter (isJust . filename)
        <$> getHistories
    ds <- fmap catMaybes $ forM dels $ \h -> do
        case filename h of
            Nothing -> fail "not reached"
            Just n  -> if n == ""
                then fail $ "Can't create content(history id=" ++ show (order h) ++ "). Change dir_name or action."
                else return $ createUpdateContent t n h
    store ds
    let (upds, hs') = partition ((== UPDATE) . action)
            $ filter (maybe False (/= "") . filename) hs
    store
        . catMaybes
        . map (uncurry (createUpdateContent t) . f)
        $ upds
    recursiveFillupUpdateContent t $ map f hs'
  where
    f h =
        ( fromJust (filename h)
        , DirHistory (order h) (targetId h) DELETE (filename h)
        )
updatedFile t@PDF_DOC = do
    (hs, dels) <- partition ((== DELETE) . action)
        . filter (maybe False (/= "ignore") . filename)
        <$> getHistories
    let (ds1, ds2) = partition (maybe False (/= "") . filename) dels
    forM ds2 $ \h ->
        fail $ "can't sync: hisotry_id=" ++ show (order h)
                ++ " path=" ++ show (filename h)
    mapM_ checkFile hs
    store $ catMaybes $ map (createUpdateContent t "") $ ds1 ++ hs
  where
    checkFile h = maybe
        (fail $ "file not exist: id=" ++ show (order h))
        (\n -> do
            let path = filePath t h ++ "/" ++ n
            checkFileOrDirectory path >>= fileOrDir
                (fail $ "file not exist: filename=" ++ path)
                (return ())
                (fail $ "'" ++ path ++ "' is direcotry")
        ) $ filename h
updatedFile t = do
    (hs, uc) <- deleteAction t
        . map ((,) <$> filePath t <*> id)
        <$> getHistories
    store uc
    mapM_ checkFile
        $ map (\(dir, h) -> (\n -> dir ++ "/" ++ n) <$> (filename h)) hs
    store $ catMaybes $ map (uncurry $ createUpdateContent t) hs
  where
    checkFile Nothing     = fail "Update file not found."
    checkFile (Just file) = checkFileOrDirectory file >>= fileOrDir
        (return ())
        (fail $ "Update file not found: " ++ file)
        (return ())
