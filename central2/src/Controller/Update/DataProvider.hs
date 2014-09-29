{-# LANGUAGE FlexibleContexts, RankNTypes, GeneralizedNewtypeDeriving #-}

module Controller.Update.DataProvider
    ( DataProvider
    , runDataProvider
    , getConnection
    , getHistories
    , store
    , UpdateContent (..)
    , UpdateResponseKey (..)
    , FileType (..)
    , HistoryId
    ) where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader (MonadReader, ReaderT)
import qualified Control.Monad.Reader as Reader
import Control.Monad.Trans.Class (MonadTrans, lift)
import Control.Monad.Writer (MonadWriter, WriterT)
import qualified Control.Monad.Writer as Writer
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Int (Int64)
import Data.List (sort)
import qualified Data.Map as Map
import Database.HDBC (SqlValue)
import Database.Record (FromSql)

import Controller.Update.HistoryContext (History, FileAction(DELETE))
import Controller.Update.TableContext (TableName, PkColumn)
import DataSource (Connection)
import qualified Util

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
    | FILE_ACTION
  deriving (Eq, Ord, Show)

data OfficeKind
    = DAY_SERVICE
    | SERVICE_BUILDING
  deriving (Eq, Ord, Read, Show)

data FileType
    = PRESENTATION | IMAGE | TOPIC | AD | CASE | SP_PRICE | PDF_DOC
    | CATALOG | ROOM_IMG
  deriving (Eq, Ord, Read, Show)

instance ToJSON FileType where
    toJSON = toJSON . show

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
        , type_ :: FileType
        , action_2 :: FileAction
        , officeId :: Integer
        , subDir :: String
        }
    | UpdatePdfDoc
        { name_2 :: String
        , type_2 :: FileType
        , action_3 :: FileAction
        }

instance Eq UpdateContent where
    (UpdateData i1 a1 t1 _ _) == (UpdateData i2 a2 t2 _ _) =
        i1 == i2 && a1 == a2 && t1 == t2
    (UpdateOfficeFile n1 t1 _ i1 s1) == (UpdateOfficeFile n2 t2 _ i2 s2) =
        n1 == n2 && t1 == t2 && i1 == i2 && s1 == s2
    (UpdatePdfDoc n1 t1 _) == (UpdatePdfDoc n2 t2 _) = n1 == n2 && t1 == t2
    _ == _ = False

instance Ord UpdateContent where
    (UpdateData i1 a1 t1 _ _) <= (UpdateData i2 a2 t2 _ _) =
        i1 <= i2 && a1 <= a2 && t1 <= t2
    (UpdateOfficeFile n1 t1 _ i1 s1) <= (UpdateOfficeFile n2 t2 _ i2 s2) =
        n1 <= n2 && t1 <= t2 && i1 <= i2 && s1 <= s2
    (UpdatePdfDoc n1 t1 _) <= (UpdatePdfDoc n2 t2 _) = n1 <= n2 && t1 <= t2
    (UpdateData _ _ _ _ _) <= _ = True
    _ <= (UpdateData _ _ _ _ _) = False
    _ <= (UpdatePdfDoc _ _ _) = True
    (UpdatePdfDoc _ _ _) <= _ = False

toJSON' :: [(UpdateResponseKey, Value)] -> Value
toJSON' = toJSON . Map.mapKeys show . Map.fromList

instance ToJSON UpdateContent where
    toJSON (UpdateData i a t p d) = toJSON'
        [ (DAT_INDEX, toJSON i)
        , (DAT_ACTION, toJSON a)
        , (DAT_TABLE, toJSON t)
        , (DAT_PK_COLUMN, toJSON p)
        , (DAT_DATA, toJSON d)
        ]
    toJSON (UpdateOfficeFile _ _ _ o _) = toJSON'
        [ (OFFICE_KIND, toJSON $ show DAY_SERVICE)
        , (OFFICE_ID, toJSON o)
        ]
    toJSON (UpdatePdfDoc n t a) = toJSON'
        [ (FILE_NAME, toJSON n)
        , (FILE_TYPE, toJSON t)
        , (FILE_URL, toJSON (if a == DELETE
            then ""
            else ("/dataupdate/updatefile/pdfdoc?fineName=" ++ n)))
        , (FILE_ACTION, toJSON a)
        ]

type HistoryId = Int64

newtype DataProvider m a = DataProviderT
    { runDataProviderT
        :: WriterT [(HistoryId, UpdateContent)] (ReaderT (Connection, [History]) m) a
    }
  deriving
    ( Functor, Applicative, Monad, MonadIO
    , MonadReader (Connection, [History])
    , MonadWriter [(HistoryId, UpdateContent)]
    )

instance MonadTrans DataProvider where
    lift = DataProviderT . lift . lift

runDataProvider
    :: (Functor m, Monad m, FromSql SqlValue a, ToJSON a)
    => Connection -> [History] -> DataProvider m a -> m [UpdateContent]
runDataProvider conn hs
    = fmap (Util.unique . map snd . sort)
    . flip Reader.runReaderT (conn, hs)
    . Writer.execWriterT
    . runDataProviderT

getConnection :: Monad m => DataProvider m Connection
getConnection = Reader.reader fst

getHistories :: Monad m => DataProvider m [History]
getHistories = Reader.reader snd

store :: Monad m => [(HistoryId, UpdateContent)] -> DataProvider m ()
store = Writer.tell
