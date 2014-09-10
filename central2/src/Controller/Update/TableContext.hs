module Controller.Update.TableContext
    ( TableName, PkColumn, Fields
    , TableContext (..)
    ) where

import Data.Int (Int32)
import Database.Relational.Query (Relation, Pi)

type TableName = String
type PkColumn = String
type Fields = [String]

data TableContext a = TableContext
    { tableRel :: Relation () a
    , officeId :: (a -> Int32)
    , officeId' :: Pi a Int32
    , tableName :: TableName
    , pkName :: PkColumn
    , fields :: Fields
    }
