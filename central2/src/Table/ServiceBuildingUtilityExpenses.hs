{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingUtilityExpenses where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Maybe (fromJust)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_utility_expenses"
deriveJSON defaultOptions ''ServiceBuildingUtilityExpenses
mkFields ''ServiceBuildingUtilityExpenses

tableContext :: TableContext ServiceBuildingUtilityExpenses
tableContext = TableContext
    serviceBuildingUtilityExpenses
    (fromIntegral . fromJust . sbId)
    (fromIntegral . fromJust |$| sbId')
    "service_building_utility_expenses"
    "sb_id"
    fields
    NoParam
