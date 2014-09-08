{-# LANGUAGE ExistentialQuantification, FlexibleContexts #-}

module Table.Types
    where

import Data.Aeson (ToJSON)
import Data.Int (Int32)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query

type TableName = String
type PkColumn = String
type Fields = [String]

data TableContext = forall a. (ToJSON a, FromSql SqlValue a) => TableContext
    { relation :: Relation () a
    , officeId :: (a -> Int32)
    , officeId' :: Pi a Int32
    , tableName :: TableName
    , pkColumn :: PkColumn
    , fields :: Fields
    }
