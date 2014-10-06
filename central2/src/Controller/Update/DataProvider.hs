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
    , Index
    , Name
    , OfficeId
    , SbId
    , SubDir
    ) where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader (MonadReader, ReaderT)
import qualified Control.Monad.Reader as Reader
import Control.Monad.Trans.Class (MonadTrans, lift)
import Control.Monad.Writer (MonadWriter, WriterT)
import qualified Control.Monad.Writer as Writer
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Int (Int32, Int64)
import Data.List (intercalate, sort)
import qualified Data.Map as Map
import Data.Monoid (mconcat)
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
    | CATALOG | ROOM_IMG | SB FileType
  deriving (Eq, Ord, Read, Show)

instance ToJSON FileType where
    toJSON = toJSON . show

type Index = Integer
type Name = String
type OfficeId = Int32
type SbId = Int32
type SubDir = String

data UpdateContent
    = UpdateData Index FileAction TableName PkColumn [Value]
    | UpdateOfficeFile Name FileType FileAction OfficeId SubDir
    | UpdatePdfDoc Name FileType FileAction
    | UpdateTopic Name FileType FileAction
    | UpdateCatalog Name FileType FileAction
    | UpdateServiceBuildingFile Name FileType FileAction SbId SubDir

instance Eq UpdateContent where
    UpdateData i1 a1 t1 _ _ == UpdateData i2 a2 t2 _ _ =
        i1 == i2 && a1 == a2 && t1 == t2
    UpdateOfficeFile n1 t1 _ i1 s1 == UpdateOfficeFile n2 t2 _ i2 s2 =
        n1 == n2 && t1 == t2 && i1 == i2 && s1 == s2
    UpdatePdfDoc n1 t1 _ == UpdatePdfDoc n2 t2 _ = n1 == n2 && t1 == t2
    UpdateTopic n1 t1 _ == UpdateTopic n2 t2 _ = n1 == n2 && t1 == t2
    UpdateCatalog n1 t1 _ == UpdateCatalog n2 t2 _ = n1 == n2 && t1 == t2
    UpdateServiceBuildingFile n1 t1 _ i1 s1 == UpdateServiceBuildingFile n2 t2 _ i2 s2 =
        n1 == n2 && t1 == t2 && i1 == i2 && s1 == s2
    _ == _ = False

instance Ord UpdateContent where
    UpdateData i1 a1 t1 _ _ `compare` UpdateData i2 a2 t2 _ _ =
        mconcat [compare i1 i2, compare a1 a2, compare t1 t2]
    UpdateOfficeFile n1 t1 _ i1 s1 `compare` UpdateOfficeFile n2 t2 _ i2 s2 =
        mconcat [compare n1 n2, compare t1 t2, compare i1 i2, compare s1 s2]
    UpdatePdfDoc n1 t1 _ `compare` UpdatePdfDoc n2 t2 _ =
        mconcat [compare n1 n2, compare t1 t2]
    UpdateTopic n1 t1 _ `compare` UpdateTopic n2 t2 _ =
        mconcat [compare n1 n2, compare t1 t2]
    UpdateCatalog n1 t1 _ `compare` UpdateCatalog n2 t2 _ =
        mconcat [compare n1 n2, compare t1 t2]
    UpdateServiceBuildingFile n1 t1 _ i1 s1 `compare` UpdateServiceBuildingFile n2 t2 _ i2 s2 =
        mconcat [compare n1 n2, compare t1 t2, compare i1 i2, compare s1 s2]

    UpdateData _ _ _ _ _ `compare` _ = LT
    _ `compare` UpdateData _ _ _ _ _ = GT
    UpdateOfficeFile _ _ _ _ _ `compare` _ = LT
    _ `compare` UpdateOfficeFile _ _ _ _ _ = GT
    UpdatePdfDoc _ _ _ `compare` _ = LT
    _ `compare` UpdatePdfDoc _ _ _ = GT
    UpdateTopic _ _ _ `compare` _ = LT
    _ `compare` UpdateTopic _ _ _ = GT
    UpdateCatalog _ _ _ `compare` _ = LT
    _ `compare` UpdateCatalog _ _ _ = GT

toJSON' :: [(UpdateResponseKey, Value)] -> Value
toJSON' = toJSON . Map.mapKeys show . Map.fromList

updateFile
    :: String
    -> FileType
    -> FileAction
    -> [String]
    -> Value
updateFile name typ act pathParams = toJSON'
    [ (FILE_NAME, toJSON name)
    , (FILE_TYPE, toJSON typ)
    , (FILE_URL, toJSON (if act == DELETE
        then ""
        else "/dataupdate/updatefile" ++ path ++ "?" ++ ps [("fileName", name)]))
    , (FILE_ACTION, toJSON act)
    ]
  where
    ps = intercalate "&" . map (\(k, v) -> k ++ "=" ++ v)
    path = concatMap ("/" ++) pathParams

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
    toJSON (UpdatePdfDoc n t a) = updateFile n t a ["pdfdoc"]
    toJSON (UpdateTopic n t a) = updateFile n t a ["topic"]
    toJSON (UpdateCatalog n t a) = updateFile n t a ["catalog"]
    toJSON (UpdateServiceBuildingFile n t a i d) =
        updateFile n t a ["SERVICE_BUILDING", show i, d]

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
