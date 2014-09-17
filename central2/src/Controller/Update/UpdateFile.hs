module Controller.Update.UpdateFile
    ( updatedFile
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
--import Database.HDBC (SqlValue)
--import Database.Record (FromSql)
import Text.Printf (printf)

import Controller.Update.DataProvider (DataProvider, getHistories)

updatedFile :: (Functor m, MonadIO m)--, FromSql SqlValue a, ToJSON a)
    => String -> DataProvider m ()
updatedFile path = do
    hs <- getHistories
    liftIO $ mapM_ putStrLn $ subDirs hs
    undefined
  where
    subDirs =  map $ printf path . fst
