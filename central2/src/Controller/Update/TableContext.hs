{-# LANGUAGE ExistentialQuantification, RankNTypes #-}

module Controller.Update.TableContext
    ( TableName, PkColumn, Fields
    , TableContext (..)
    , TableContextParam (..)
    , Position (..)
    , pos
    ) where

import Control.Applicative
import Control.Arrow ((&&&))
import Control.Monad.IO.Class (MonadIO)
import Data.Int (Int32)
import Database.Relational.Query (Relation, Pi)

import DataSource (Connection)

type TableName = String
type PkColumn = String
type Fields = [String]

data Position = Pos Double Double

pos :: (a -> Maybe String)
    -> (a -> Maybe String)
    -> Maybe a
    -> Maybe Position
pos lx ly mk = do
    (x, y) <- (fmap read . lx &&& fmap read . ly) <$> mk
    Pos <$> x <*> y

data TableContextParam a
    = NoParam
    | NewsParam 
        { relTable :: Relation (Maybe Int32, Maybe Int32) a
        , qParam :: IO (Maybe Int32, Maybe Int32)
        }
    | TopicParam
        { deviceId :: Maybe Int32
        , officeFilter :: (MonadIO m, Functor m)
            => Connection -> m (Maybe Position) -> a -> m Bool
        }

data TableContext a = TableContext
    { tableRel :: Relation () a
    , officeId :: (a -> Int32)
    , officeId' :: Pi a Int32
    , tableName :: TableName
    , pkName :: PkColumn
    , fields :: Fields
    , param :: TableContextParam a
    }
