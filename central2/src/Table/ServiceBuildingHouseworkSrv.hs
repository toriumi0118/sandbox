{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingHouseworkSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_housework_srv"
deriveJSON defaultOptions ''ServiceBuildingHouseworkSrv
mkFields ''ServiceBuildingHouseworkSrv

tableContext :: TableContext ServiceBuildingHouseworkSrv
tableContext = TableContext
    serviceBuildingHouseworkSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_housework_srv"
    "sb_id"
    fields
    NoParam
