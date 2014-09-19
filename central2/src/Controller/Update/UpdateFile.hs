module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Maybe (catMaybes)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, UpdateContent(UpdateOfficeFile), FileType(IMAGE))
import Controller.Update.HistoryContext (History(History, FileHistory), FileAction(DELETE), targetId)

createUpdateContent :: String -> History -> Maybe UpdateContent
createUpdateContent path (FileHistory _ i a n) = Just $
    UpdateOfficeFile n IMAGE a (fromIntegral i) path
createUpdateContent _ _ = Nothing

deleteAction :: String -> [History] -> ([History], [UpdateContent])
deleteAction path = go [] []
  where
    go rs cs []                                = (rs, reverse $ catMaybes cs)
    go rs cs (History _ _ _:hs)                = go rs cs hs
    go rs cs (h@(FileHistory _ _ DELETE _):hs) =
        go rs (createUpdateContent path h:cs) hs
    go rs cs _                                 = undefined

updatedFile :: (Functor m, MonadIO m)--, FromSql SqlValue a, ToJSON a)
    => String -> DataProvider m ()
updatedFile path = do
    (hs, uc) <- deleteAction path <$> getHistories
    undefined
  where
    subDirs :: [History] -> [String]
    subDirs =  map $ printf path . targetId
