{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingMealHelpSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_meal_help_srv"
deriveJSON defaultOptions ''ServiceBuildingMealHelpSrv
mkFields ''ServiceBuildingMealHelpSrv

tableContext :: TableContext ServiceBuildingMealHelpSrv
tableContext = TableContext
    serviceBuildingMealHelpSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_meal_help_srv"
    "sb_id"
    fields
    NoParam
