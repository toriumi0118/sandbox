{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingTrial where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_trial"
deriveJSON defaultOptions ''ServiceBuildingTrial
mkFields ''ServiceBuildingTrial

tableContext :: TableContext ServiceBuildingTrial
tableContext = TableContext
    serviceBuildingTrial
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_trial"
    "sb_id"
    fields
    NoParam
