{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingMealSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_meal_srv"
deriveJSON defaultOptions ''ServiceBuildingMealSrv
mkFields ''ServiceBuildingMealSrv

tableContext :: TableContext ServiceBuildingMealSrv
tableContext = TableContext
    serviceBuildingMealSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_meal_srv"
    "sb_id"
    fields
    NoParam
