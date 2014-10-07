{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingKeepHealthSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_keep_health_srv"
deriveJSON defaultOptions ''ServiceBuildingKeepHealthSrv
mkFields ''ServiceBuildingKeepHealthSrv

tableContext :: TableContext ServiceBuildingKeepHealthSrv
tableContext = TableContext
    serviceBuildingKeepHealthSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_keep_health_srv"
    "sb_id"
    fields
    NoParam
