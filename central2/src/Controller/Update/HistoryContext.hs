{-# LANGUAGE TemplateHaskell, FlexibleInstances, MultiParamTypeClasses #-}

module Controller.Update.HistoryContext
    ( HistoryContext
        ( HistoryContext
        , hcRel
        , hcPk
        , hcIdKey
        , hcSelect
        )
    , History
        ( History
        , hOfficeId
        , hAction
        )
    , FileAction
        ( INSERT
        , DELETE
        , UPDATE
        )
    ) where

import Control.Applicative
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Int (Int32, Int64)
import Database.HDBC (SqlValue(SqlString))
import Database.HDBC.Record.Persistable ()
import Database.Record.FromSql (FromSql(recordFromSql), createRecordFromSql)
import Database.Relational.Query

import Controller.Types.VersionupHisIds (VersionupHisIds)

data FileAction = INSERT | DELETE | UPDATE
  deriving (Show, Read, Eq)

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
        { hOfficeId :: Int32
        , hAction :: FileAction
        }

instance ProductConstructor (Int32 -> FileAction -> History) where
    productConstructor = History

instance FromSql SqlValue History where
    recordFromSql = History <$> recordFromSql <*> recordFromSql

data HistoryContext a = HistoryContext
    { hcRel :: Relation () a
    , hcPk :: Pi a Int64
    , hcIdKey :: VersionupHisIds -> Integer
    , hcSelect :: Projection Flat a -> Projection Flat History
    }
