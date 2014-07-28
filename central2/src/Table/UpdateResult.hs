{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.UpdateResult where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.HDBC.Query.TH (defineTableFromDB)
import Database.HDBC.Schema.PostgreSQL (driverPostgreSQL)
import Database.Record.TH (derivingShow)
import Database.Relational.Query
import Data.Time.LocalTime (ZonedTime)
import Data.Int (Int32)

import DataSource (connect)

$(defineTableFromDB
    connect
    driverPostgreSQL
    "public"
    "update_result"
    [derivingShow])

$(deriveJSON defaultOptions ''UpdateResult)

insertUpdateResult' :: Insert (((Maybe String, ZonedTime), Int32), Int32)
insertUpdateResult' = typedInsert
    (message' >< prcDate' >< succeed' >< deviceId')
    tableOfUpdateResult
