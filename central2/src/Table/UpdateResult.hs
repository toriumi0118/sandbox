{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.UpdateResult where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query
import Data.Time.LocalTime (LocalTime)
import Data.Int (Int32, Int64)

import Controller.Types.Class ()
import DataSource (defineTable)

$(defineTable "update_result")

$(deriveJSON defaultOptions ''UpdateResult)

insertUpdateResult' :: Insert (Maybe String, LocalTime, Int32, Int64)
insertUpdateResult' = typedInsert
    ((,,,) |$| message' |*| prcDate' |*| succeed' |*| deviceId')
    tableOfUpdateResult
