{-# LANGUAGE ExistentialQuantification #-}

module Controller.Update.TableContext
    ( TableName, PkColumn, Fields
    , TableContext (..)
    , TableContextParam (..)
    ) where

import Data.Int (Int32)
import Database.Relational.Query (Relation, Pi)

type TableName = String
type PkColumn = String
type Fields = [String]

data TableContextParam a
    = NoParam
    | NewsParam (Relation (Maybe Int32, Maybe Int32) a)
    | TopicParam {isWelmo :: Bool}

data TableContext a = TableContext
    { tableRel :: Relation () a
    , officeId :: (a -> Int32)
    , officeId' :: Pi a Int32
    , tableName :: TableName
    , pkName :: PkColumn
    , fields :: Fields
    , param :: TableContextParam a
    }
