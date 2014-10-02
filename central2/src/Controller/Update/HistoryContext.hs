{-# LANGUAGE TemplateHaskell, FlexibleInstances, MultiParamTypeClasses #-}

module Controller.Update.HistoryContext
    ( HistoryContext
        ( HistoryContext
        , hcRel
        , hcOrder
        , hcIdKey
        , hcConv
        )
    , History
        ( History
        )
    , order
    , targetId
    , action
    , targetPkValue
    , filename
    , dirname
    , FileAction
        ( INSERT
        , DELETE
        , UPDATE
        )
    ) where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Int (Int32, Int64)
import Data.Monoid (mconcat)
import Database.HDBC (SqlValue(SqlString))
import Database.HDBC.Record.Persistable ()
import Database.Record.FromSql (FromSql(recordFromSql), createRecordFromSql)
import Database.Relational.Query

import Controller.Types.VersionupHisIds (VersionupHisIds)

data FileAction = INSERT | DELETE | UPDATE
  deriving (Show, Read, Eq, Ord)

deriveJSON defaultOptions ''FileAction

instance ProductConstructor (String -> FileAction) where
    productConstructor = read

instance FromSql SqlValue FileAction where
    recordFromSql = createRecordFromSql f
      where
        f []              = error "can't convert from SqlValue to FileAction"
        f (SqlString s:_) = (read s, [])
        f (_:ss)          = f ss

data History
    = History
        { order :: Int64
        , targetId :: Int32
        , targetPkValue :: Maybe Int32
        , action :: FileAction
        , filename :: Maybe String
        , dirname :: Maybe String
        }

instance Eq History where
    History _ i1 p1 _ f1 _ == History _ i2 p2 _ f2 _ =
        i1 == i2 && p1 == p2 && f1 == f2

instance Ord History where
    History _ i1 p1 _ f1 _ `compare` History _ i2 p2 _ f2 _ = mconcat
        [compare i1 i2, compare p1 p2, compare f1 f2]

data HistoryContext a = HistoryContext
    { hcRel :: Relation () a
    , hcOrder :: Pi a Int64
    , hcIdKey :: VersionupHisIds -> Integer
    , hcConv :: a -> History
    }
