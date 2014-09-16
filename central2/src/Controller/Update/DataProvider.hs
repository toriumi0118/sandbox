{-# LANGUAGE TemplateHaskell, FlexibleContexts, RankNTypes, GeneralizedNewtypeDeriving #-}

module Controller.Update.DataProvider
    ( DataProvider
    , runDataProvider
    , getConnection
    , getHistories
    , store
    , UpdateData (..)
    , History
    , FileAction (..)
    ) where

import Control.Applicative
import Control.Monad.Reader (MonadReader, ReaderT)
import qualified Control.Monad.Reader as Reader
import Control.Monad.Trans.Class (MonadTrans, lift)
import Control.Monad.Writer (MonadWriter, WriterT)
import qualified Control.Monad.Writer as Writer
import Data.Aeson (Value, ToJSON)
import Data.Aeson.TH (deriveJSON, defaultOptions, fieldLabelModifier)
import Data.Int (Int32)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)

import Controller.Update.TableContext (TableName, PkColumn)
import DataSource (Connection)
import Util (initIf)

data FileAction = INSERT | DELETE | UPDATE
  deriving (Show, Read, Eq)

deriveJSON defaultOptions ''FileAction

data UpdateData = UpdateData
    { index :: Integer
    , action :: FileAction
    , table :: TableName
    , pkColumn :: PkColumn
    , data' :: [Value]
    }

deriveJSON defaultOptions{fieldLabelModifier = initIf (=='\'')} ''UpdateData

type History = (Int32, FileAction)

newtype DataProvider m a = DataProviderT
    { runDataProviderT
        :: WriterT [Maybe [UpdateData]] (ReaderT (Connection, [History]) m) a
    }
  deriving
    ( Functor, Applicative, Monad
    , MonadReader (Connection, [History])
    , MonadWriter [Maybe [UpdateData]]
    )

instance MonadTrans DataProvider where
    lift = DataProviderT . lift . lift

runDataProvider
    :: (Functor m, Monad m, FromSql SqlValue a, ToJSON a)
    => Connection -> [History] -> DataProvider m a -> m [Maybe [UpdateData]]
runDataProvider conn hs
    = flip Reader.runReaderT (conn, hs) . Writer.execWriterT . runDataProviderT

getConnection :: Monad m => DataProvider m Connection
getConnection = Reader.reader fst

getHistories :: Monad m => DataProvider m [History]
getHistories = Reader.reader snd

store :: Monad m => [Maybe [UpdateData]] -> DataProvider m ()
store = Writer.tell
