module Table.Types
    where

import Data.Int (Int32)
import Database.Relational.Query

type TableName = String
type PkColumn = String
type Fields = [String]

data TableContext a = TableContext
    { relation :: Relation () a
    , officeId :: (a -> Int32)
    , officeId' :: Pi a Int32
    , tableName :: TableName
    , pkColumn :: PkColumn
    , fields :: Fields
    }
