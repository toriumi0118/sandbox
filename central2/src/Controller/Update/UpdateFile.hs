module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Char (toLower)
import Data.Foldable (toList)
import Data.List (isInfixOf)
import Data.Maybe (catMaybes)
import System.Directory (doesFileExist, doesDirectoryExist, getDirectoryContents)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, UpdateContent(UpdateOfficeFile), FileType(..), HistoryId, store)
import Controller.Update.HistoryContext (History(History, FileHistory, hfFileName), FileAction(DELETE, UPDATE), targetId, action)

createUpdateContent
    :: FileType -> FilePath -> History -> Maybe (HistoryId, UpdateContent)
createUpdateContent PRESENTATION _ (History hid i DELETE) = Just
    (hid, UpdateOfficeFile "" PRESENTATION DELETE (fromIntegral i) "presentation")
createUpdateContent PRESENTATION _ (History hid i UPDATE) = Just
    (hid, UpdateOfficeFile "" PRESENTATION DELETE (fromIntegral i) "presentation")
createUpdateContent PRESENTATION path (History hid i act) = Just
    (hid, UpdateOfficeFile path PRESENTATION act (fromIntegral i) "presentation")
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

updatedFile :: (Applicative m, MonadIO m) => FileType -> DataProvider m ()
updatedFile t@PRESENTATION = do
    fhs <- map ((,) <$> filePath t <*> id) <$> getHistories
    let (hs, uc) = deleteAction t fhs
    store uc
    store
        $ catMaybes
        $ map (uncurry $ createUpdateContent t)
        $ filter isUpdate hs
    -- XXX: includePath
    mapM checkFile fhs >>= mapM_ g
  where
    isUpdate (_, h) = action h == UPDATE
    checkFile fh = (,) <$> checkFileOrDirectory (fst fh) <*> return fh
    g (NotExist, (path, _)) = fail $ "Update file not found: " ++ path
    g (File, (path, h)) = if "gitkeeper" `isInfixOf` path
        then return ()
        else store $ toList $ createUpdateContent t path h
    g (Directory, (path, h)) = do
        cs <- liftIO $ getDirectoryContents path
        mapM_ (\c -> checkFile (c, h) >>= g) cs
updatedFile t = do
    (hs, uc) <- deleteAction t . map ((,) <$> filePath t <*> id)
        <$> getHistories
    store uc
    mapM_ checkFile $ map (\(dir, h) -> dir ++ "/" ++ hfFileName h) hs
    store $ catMaybes $ map (uncurry $ createUpdateContent t) hs
  where
    checkFile file = checkFileOrDirectory file >>= fileOrDir
        (return ())
        (fail $ "Update file not found: " ++ file)
        (return ())
