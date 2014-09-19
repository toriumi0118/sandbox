module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Applicative
import Control.Monad (unless)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Maybe (catMaybes)
import System.Directory (doesFileExist)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, UpdateContent(UpdateOfficeFile), FileType(IMAGE), HistoryId, store)
import Controller.Update.HistoryContext (History(History, FileHistory, hfFileName), FileAction(DELETE), targetId)

createUpdateContent :: FilePath -> History -> Maybe (HistoryId, UpdateContent)
createUpdateContent path (FileHistory hid i a n) = Just (hid,
    UpdateOfficeFile n IMAGE a (fromIntegral i) path)
createUpdateContent _ _ = Nothing

deleteAction
    :: [(FilePath, History)] -> ([(FilePath, History)], [(HistoryId, UpdateContent)])
deleteAction = go [] []
  where
    go rs cs [] = (rs, reverse $ catMaybes cs)
    go rs cs ((_, History _ _ _):hs)                   = go rs cs hs
    go rs cs ((path, h@(FileHistory _ _ DELETE _)):hs) =
        go rs (createUpdateContent path h:cs) hs
    go rs cs (h:hs)                                    = go (h:rs) cs hs

checkFiles :: MonadIO m
    => (FilePath, History) -> m ()
checkFiles (subDir, his) = do
    b <- liftIO $ doesFileExist file
    unless b $ fail $ "Update file not found: " ++ file
  where
    file = subDir ++ "/" ++ hfFileName his

updatedFile :: (Functor m, MonadIO m) => String -> DataProvider m ()
updatedFile pathFmt = do
    (hs, uc) <- deleteAction . map ((,) <$> subDir <*> id) <$> getHistories
    store uc
    mapM_ checkFiles hs
    store $ catMaybes $ map (uncurry createUpdateContent) hs
  where
    subDir =  printf pathFmt . targetId
