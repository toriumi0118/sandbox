{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.UpdateResult where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query
import Data.Time.LocalTime (ZonedTime)
import Data.Int (Int32)

import DataSource (defineTable)

$(defineTable "update_result")

$(deriveJSON defaultOptions ''UpdateResult)

insertUpdateResult' :: Insert (((Maybe String, ZonedTime), Int32), Int32)
insertUpdateResult' = typedInsert
    (message' >< prcDate' >< succeed' >< deviceId')
    tableOfUpdateResult
