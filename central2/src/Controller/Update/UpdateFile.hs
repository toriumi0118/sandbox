module Controller.Update.UpdateFile
    ( updatedFile
    , FileProviderType
        ( OfficeImage
        , OfficePresentation
        , OfficeAd
        )
    ) where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Foldable (toList)
import Data.List (isInfixOf)
import Data.Maybe (catMaybes)
import System.Directory (doesFileExist, doesDirectoryExist, getDirectoryContents)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, UpdateContent(UpdateOfficeFile), FileType(IMAGE, PRESENTATION), HistoryId, store)
import Controller.Update.HistoryContext (History(History, FileHistory, hfFileName), FileAction(DELETE, UPDATE), targetId, action)

data FileProviderType = OfficeImage | OfficePresentation | OfficeAd

createUpdateContent
    :: FileProviderType -> FilePath -> History -> Maybe (HistoryId, UpdateContent)
createUpdateContent OfficeImage path (FileHistory hid i a n) = Just
    (hid, UpdateOfficeFile n IMAGE a (fromIntegral i) path)
createUpdateContent OfficePresentation _ (History hid i DELETE) = Just
    (hid, UpdateOfficeFile "" PRESENTATION DELETE (fromIntegral i) "presentation")
createUpdateContent OfficePresentation _ (History hid i UPDATE) = Just
    (hid, UpdateOfficeFile "" PRESENTATION DELETE (fromIntegral i) "presentation")
createUpdateContent OfficePresentation path (History hid i act) = Just
    (hid, UpdateOfficeFile path PRESENTATION act (fromIntegral i) "presentation")
createUpdateContent _ _ _ = Nothing

deleteAction
    :: FileProviderType
    -> [(FilePath, History)]
    -> ([(FilePath, History)], [(HistoryId, UpdateContent)])
deleteAction t = go [] []
  where
    go rs cs [] = (rs, reverse $ catMaybes cs)
    go rs cs ((_, History _ _ _):hs)                   = go rs cs hs
    go rs cs ((path, h@(FileHistory _ _ DELETE _)):hs) =
        go rs (createUpdateContent t path h:cs) hs
    go rs cs (h:hs)                                    = go (h:rs) cs hs

filePathFormat :: FileProviderType -> String
filePathFormat OfficeImage = "data/office/office%d/image"
filePathFormat OfficePresentation = "data/office/office%d/presentation"
filePathFormat OfficeAd = "data/office/office%d/ad"

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

updatedFile
    :: (Applicative m, MonadIO m) => FileProviderType -> DataProvider m ()
updatedFile t@OfficePresentation = do
    fhs <- map ((,) <$> subDir <*> id) <$> getHistories
    let (hs, uc) = deleteAction t fhs
    store uc
    store
        $ catMaybes
        $ map (uncurry $ createUpdateContent t)
        $ filter isUpdate hs
    -- XXX: includePath
    mapM checkFile fhs >>= mapM_ g
  where
    subDir =  printf (filePathFormat t) . targetId
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
    (hs, uc) <- deleteAction t . map ((,) <$> subDir <*> id) <$> getHistories
    store uc
    mapM_ checkFile $ map (\(dir, h) -> dir ++ "/" ++ hfFileName h) hs
    store $ catMaybes $ map (uncurry $ createUpdateContent t) hs
  where
    subDir =  printf (filePathFormat t) . targetId
    checkFile file = checkFileOrDirectory file >>= fileOrDir
        (return ())
        (fail $ "Update file not found: " ++ file)
        (return ())
