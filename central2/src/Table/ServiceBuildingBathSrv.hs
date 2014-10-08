{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingBathSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_bath_srv"
deriveJSON defaultOptions ''ServiceBuildingBathSrv
mkFields ''ServiceBuildingBathSrv

tableContext :: TableContext ServiceBuildingBathSrv
tableContext = TableContext
    serviceBuildingBathSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_bath_srv"
    "sb_id"
    fields
    NoParam
