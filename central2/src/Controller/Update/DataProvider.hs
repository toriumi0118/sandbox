{-# LANGUAGE TemplateHaskell, FlexibleContexts, RankNTypes, GeneralizedNewtypeDeriving #-}

module Controller.Update.DataProvider
    ( DataProvider
    , runDataProvider
    , getConnection
    , getHistories
    , store
    , UpdateContent (..)
    , History
    , FileAction (..)
    , UpdateResponseKey (..)
    ) where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader (MonadReader, ReaderT)
import qualified Control.Monad.Reader as Reader
import Control.Monad.Trans.Class (MonadTrans, lift)
import Control.Monad.Writer (MonadWriter, WriterT)
import qualified Control.Monad.Writer as Writer
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Int (Int32)
import qualified Data.Map as Map
import Database.HDBC (SqlValue)
import Database.Record (FromSql)

import Controller.Update.TableContext (TableName, PkColumn)
import DataSource (Connection)

data FileAction = INSERT | DELETE | UPDATE
  deriving (Show, Read, Eq)

deriveJSON defaultOptions ''FileAction

data UpdateResponseKey
    = DATA
    | DAT_INDEX
    | DAT_ACTION
    | DAT_TABLE
    | DAT_PK_COLUMN
    | DAT_DATA
    | FILES
    | OFFICE_KIND
    | OFFICE_ID
    | SERVICE_BUILDING_ID
    | FILE_NAME
    | FILE_URL
    | FILE_TYPE
    | FILE_ACtION
  deriving (Eq, Ord, Show)

data UpdateContent
    = UpdateData
        { index :: Integer
        , action :: FileAction
        , table :: TableName
        , pkColumn :: PkColumn
        , data_ :: [Value]
        }
    | UpdateOfficeFile
        { name :: String
        , type_ :: String
        , action_2 :: String
        , officeId :: Integer
        , subDir :: String
        }

instance ToJSON UpdateContent where
    toJSON (UpdateData i a t p d) = toJSON $ Map.mapKeys show $ Map.fromList
        [ (DAT_INDEX, toJSON i)
        , (DAT_ACTION, toJSON a)
        , (DAT_TABLE, toJSON t)
        , (DAT_PK_COLUMN, toJSON p)
        , (DAT_DATA, toJSON d)
        ]
    toJSON (UpdateOfficeFile i t a o s) = undefined --toJSON $ Map.mapKeys show $ Map.fromList

type History = (Int32, FileAction)

newtype DataProvider m a = DataProviderT
    { runDataProviderT
        :: WriterT [Maybe [UpdateContent]] (ReaderT (Connection, [History]) m) a
    }
  deriving
    ( Functor, Applicative, Monad, MonadIO
    , MonadReader (Connection, [History])
    , MonadWriter [Maybe [UpdateContent]]
    )

instance MonadTrans DataProvider where
    lift = DataProviderT . lift . lift

runDataProvider
    :: (Functor m, Monad m, FromSql SqlValue a, ToJSON a)
    => Connection -> [History] -> DataProvider m a -> m [Maybe [UpdateContent]]
runDataProvider conn hs
    = flip Reader.runReaderT (conn, hs) . Writer.execWriterT . runDataProviderT

getConnection :: Monad m => DataProvider m Connection
getConnection = Reader.reader fst

getHistories :: Monad m => DataProvider m [History]
getHistories = Reader.reader snd

store :: Monad m => [Maybe [UpdateContent]] -> DataProvider m ()
store = Writer.tell
