module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories, History)

updatedFile :: (Functor m, MonadIO m)--, FromSql SqlValue a, ToJSON a)
    => String -> DataProvider m ()
updatedFile path = do
    hs <- getHistories
    undefined
  where
    subDirs :: [History] -> [String]
    subDirs =  map $ printf path . fst
