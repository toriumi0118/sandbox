{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingMealDeliverySrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_meal_delivery_srv"
deriveJSON defaultOptions ''ServiceBuildingMealDeliverySrv
mkFields ''ServiceBuildingMealDeliverySrv

tableContext :: TableContext ServiceBuildingMealDeliverySrv
tableContext = TableContext
    serviceBuildingMealDeliverySrv
    sbId
    sbId'
    "service_building_meal_delivery_srv"
    "sb_id"
    fields
    NoParam
