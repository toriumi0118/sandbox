module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Applicative
import Control.Arrow (second)
import Control.Monad (forM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Char (toLower)
import Data.Foldable (toList)
import Data.List (isInfixOf, partition)
import Data.Maybe (isJust, fromJust, fromMaybe)
import System.Directory (doesFileExist, doesDirectoryExist, getDirectoryContents)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, UpdateContent(..), FileType(..), HistoryId, store)
import Controller.Update.HistoryContext (History(History), FileAction(DELETE, UPDATE), order, targetId, action, filename)
import Util (replaceSuffix)

pdfToPng :: FilePath -> FilePath
pdfToPng path = fromMaybe path $ replaceSuffix ".pdf" ".png" path

createUpdateContent
    :: FileType -> FilePath -> History -> [(HistoryId, UpdateContent)]
createUpdateContent PRESENTATION _ (History hid i _ DELETE _ _) =
    [(hid, UpdateOfficeFile "" PRESENTATION DELETE i "presentation")]
createUpdateContent PRESENTATION _ (History hid i _ UPDATE _ _) =
    [(hid, UpdateOfficeFile "" PRESENTATION DELETE i "presentation")]
createUpdateContent PRESENTATION path (History hid i _ act _ _) =
    [(hid, UpdateOfficeFile path PRESENTATION act i "presentation")]
createUpdateContent TOPIC n (History hid _ _ act _ _) =
    [(hid, UpdatePdfDoc n TOPIC act)]
createUpdateContent PDF_DOC _ (History hid _ _ act (Just n) _) =
    [(hid, UpdatePdfDoc n PDF_DOC act)]
createUpdateContent CATALOG _ (History hid _ _ act (Just n) _) =
    [ (hid, UpdateCatalog n CATALOG act)
    , (hid, UpdateCatalog (pdfToPng n) CATALOG act)
    ]
createUpdateContent (SB ROOM) path (History hid i _ a (Just n) _) =
    [(hid, UpdateServiceBuildingRoomTypeImg n ROOM a i path)]
createUpdateContent (SB PRESENTATION) _ (History hid i _ DELETE _ _) =
    [(hid, UpdateServiceBuildingFile "" PRESENTATION DELETE i "presentation")]
createUpdateContent (SB PRESENTATION) _ (History hid i _ UPDATE _ _) =
    [(hid, UpdateServiceBuildingFile "" PRESENTATION DELETE i "presentation")]
createUpdateContent (SB PRESENTATION) path (History hid i _ a _ _) =
    [(hid, UpdateServiceBuildingFile path PRESENTATION a i "presentation")]
createUpdateContent (SB typ) path (History hid i _ a (Just n) _) =
    [(hid, UpdateServiceBuildingFile n typ a i path)]
createUpdateContent typ path (History hid i _ a (Just n) _) =
    [(hid, UpdateOfficeFile n typ a i path)]
createUpdateContent _ _ _ = []

deleteAction
    :: FileType
    -> [(FilePath, History)]
    -> ([(FilePath, History)], [(HistoryId, UpdateContent)])
deleteAction t = go [] []
  where
    go rs cs [] = (rs, reverse $ concat cs)
    go rs cs ((_, History _ _ _ _ Nothing _):hs)       = go rs cs hs
    go rs cs ((path, h@(History _ _ _ DELETE _ _)):hs) =
        go rs (createUpdateContent t path h:cs) hs
    go rs cs (h:hs)                                    = go (h:rs) cs hs

filePath' :: String -> FileType -> History -> FilePath
filePath' fmt typ
    = printf (fmt ++ map toLower (show typ))
    . targetId

filePath :: FileType -> History -> FilePath
filePath TOPIC = const "data/topic"
filePath PDF_DOC = const "data/pdf"
filePath CATALOG = const "data/catalog"
filePath (SB typ) = filePath' "data/servicebuilding/servicebuilding%d/" typ
filePath typ = filePath' "data/office/office%d/" typ

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

presentationFile :: (Applicative m, MonadIO m)
    => FileType -> DataProvider m ()
presentationFile t = do
    fhs <- map ((,) <$> filePath t <*> id) <$> getHistories
    let (hs, uc) = deleteAction t fhs
    store uc
    store
        $ concatMap (uncurry $ createUpdateContent t)
        $ filter isUpdate hs
    recursiveFillupUpdateContent t fhs
  where
    isUpdate (_, h) = action h == UPDATE

updatedFile :: (Applicative m, MonadIO m) => FileType -> DataProvider m ()
updatedFile t@PRESENTATION = presentationFile t
updatedFile t@(SB PRESENTATION) = presentationFile t
updatedFile t@TOPIC = do
    (hs, dels) <- partition ((== DELETE) . action)
        . filter (isJust . filename)
        <$> getHistories
    ds <- fmap concat $ forM dels $ \h -> do
        case filename h of
            Nothing -> fail "not reached"
            Just n  -> if n == ""
                then fail $ "topic can't create content(history id=" ++ show (order h) ++ "). Change dir_name or action."
                else return $ createUpdateContent t n h
    store ds
    let (upds, hs') = partition ((== UPDATE) . action . snd)
            . map f
            . filter (maybe False (/= "") . filename)
            $ hs
    store $ concatMap (uncurry $ createUpdateContent t) upds
    recursiveFillupUpdateContent t hs'
  where
    f h = (fromJust (filename h), h{action = DELETE})
updatedFile t@PDF_DOC = do
    (hs, dels) <- partition ((== DELETE) . action)
        . filter (maybe False (/= "ignore") . filename)
        <$> getHistories
    let (ds1, ds2) = partition (maybe False (/= "") . filename) dels
    forM ds2 $ \h ->
        fail $ "pdf_doc can't sync: hisotry_id=" ++ show (order h)
                ++ " path=" ++ show (filename h)
    mapM_ checkFile hs
    store $ concatMap (createUpdateContent t "") $ ds1 ++ hs
  where
    checkFile h = maybe
        (fail $ "pdf_doc file is not exist: history id=" ++ show (order h))
        (\n -> do
            let path = filePath t h ++ "/" ++ n
            checkFileOrDirectory path >>= fileOrDir
                (fail $ "file is not exist: filename=" ++ path)
                (return ())
                (fail $ "'" ++ path ++ "' is direcotry")
        ) $ filename h
updatedFile t@CATALOG = do
    (hs, dels) <- partition ((== DELETE) . action) <$> getHistories
    ds <- fmap concat $ forM dels $ \h -> if maybe False (/= "") (filename h)
        then return $ createUpdateContent t "" h
        else fail $ "catalog can't sync contents(history id=" ++ show (order h) ++ "). Change file_path or action."
    store ds
    let hs' = filter (maybe False (/= "ignore") . filename) hs
    let files = map ((,) <$> id <*> (fromJust . filename)) hs'
    mapM_ (uncurry checkFile) $ files ++ map (second pdfToPng) files
    store $ concatMap (createUpdateContent t "") hs'
  where
    checkFile h n = checkFileOrDirectory path >>= fileOrDir
        (fail $ "catalog file is not exist: filename=" ++ path)
        (return ())
        (fail $ "'" ++ path ++ "' is direcotry")
      where
        path = filePath t h ++ "/" ++ n
updatedFile t = do
    (hs, uc) <- deleteAction t
        . map ((,) <$> filePath t <*> id)
        <$> getHistories
    store uc
    mapM_ checkFile
        $ map (\(dir, h) -> (\n -> dir ++ "/" ++ n) <$> (filename h)) hs
    store $ concatMap (uncurry $ createUpdateContent t) hs
  where
    checkFile Nothing     = fail "Update file not found."
    checkFile (Just file) = checkFileOrDirectory file >>= fileOrDir
        (return ())
        (fail $ "Update file not found: " ++ file)
        (return ())
