{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingOtherExpense where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Maybe (fromJust)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_other_expense"
deriveJSON defaultOptions ''ServiceBuildingOtherExpense
mkFields ''ServiceBuildingOtherExpense

tableContext :: TableContext ServiceBuildingOtherExpense
tableContext = TableContext
    serviceBuildingOtherExpense
    (fromIntegral . fromJust . sbId)
    (fromIntegral . fromJust |$| sbId')
    "service_building_other_expense"
    "sb_id"
    fields
    NoParam
