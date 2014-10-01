{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingMimamoriSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_mimamori_srv"
deriveJSON defaultOptions ''ServiceBuildingMimamoriSrv
mkFields ''ServiceBuildingMimamoriSrv

tableContext :: TableContext ServiceBuildingMimamoriSrv
tableContext = TableContext
    serviceBuildingMimamoriSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_mimamori_srv"
    "sb_id"
    fields
    NoParam
