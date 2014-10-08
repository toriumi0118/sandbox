{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRent where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_rent"
deriveJSON defaultOptions ''ServiceBuildingRent
mkFields ''ServiceBuildingRent

tableContext :: TableContext ServiceBuildingRent
tableContext = TableContext
    serviceBuildingRent
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_rent"
    "sb_id"
    fields
    NoParam
