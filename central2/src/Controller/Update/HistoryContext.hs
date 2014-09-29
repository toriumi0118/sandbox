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
        , hTargetId
        , hAction
        , FileHistory
        , hfTargetId
        , hfAction
        , hfFileName
        )
    , targetId
    , order
    , action
    , filename
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
        { hOrder :: Int64
        , hTargetId :: Int32
        , hAction :: FileAction
        }
    | FileHistory
        { hfOrder :: Int64
        , hfTargetId :: Int32
        , hfAction :: FileAction
        , hfFileName :: String
        }

instance Eq History where
    History _ i1 _ == History _ i2 _ = i1 == i2
    FileHistory _ i1 _ _ == FileHistory _ i2 _ _ = i1 == i2
    _ == _ = False

instance Ord History where
    History _ i1 _ <= History _ i2 _ = i1 <= i2
    FileHistory _ i1 _ _ <= FileHistory _ i2 _ _ = i1 <= i2
    History _ _ _ <= FileHistory _ _ _ _ = True
    _ <= _ = False

instance ProductConstructor (Int64 -> Int32 -> FileAction -> History) where
    productConstructor = History

instance ProductConstructor (Int64 -> Int32 -> FileAction -> String -> History) where
    productConstructor = FileHistory

instance FromSql SqlValue History where
    recordFromSql = History <$> recordFromSql <*> recordFromSql <*> recordFromSql

targetId :: History -> Int32
targetId (History _ i _)       = i
targetId (FileHistory _ i _ _) = i

order :: History -> Int64
order (History i _ _) = i
order (FileHistory i _ _ _) = i

action :: History -> FileAction
action (History _ _ a) = a
action (FileHistory _ _ a _) = a

filename :: History -> Maybe String
filename (History _ _ _) = Nothing
filename (FileHistory _ _ _ n) = Just n

data HistoryContext a = HistoryContext
    { hcRel :: Relation () a
    , hcPk :: Pi a Int64
    , hcIdKey :: VersionupHisIds -> Integer
    , hcSelect :: Projection Flat a -> Projection Flat History
    }
