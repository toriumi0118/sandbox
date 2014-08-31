{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Controller.Types.Class where

import Data.Aeson (FromJSON(..), ToJSON(..))
import Data.Int (Int64)
import Data.Time (NominalDiffTime, UTCTime(..), Day(..), addUTCTime)
import Database.Relational.Query
import Database.Record (ToSql(recordToSql), wrapToSql, putRecord)

instance FromJSON NominalDiffTime where
    parseJSON = undefined

instance ToJSON NominalDiffTime where
    toJSON = toJSON . flip addUTCTime (UTCTime (ModifiedJulianDay 0) 0)

class History a where
    id :: a -> Int64
    action :: a -> String
    id' :: Pi a Int64
    action' :: Pi a String

instance ProductConstructor (a -> b -> c -> d -> (a, b, c, d)) where
    productConstructor = (,,,)

instance (ToSql q a, ToSql q b, ToSql q c, ToSql q d)
        => ToSql q (a, b, c, d) where
    recordToSql = wrapToSql $ \(a, b, c, d) -> do
        putRecord a
        putRecord b
        putRecord c
        putRecord d
