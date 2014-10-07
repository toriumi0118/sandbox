{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingAppealPoint where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_appeal_point"
deriveJSON defaultOptions ''ServiceBuildingAppealPoint
mkFields ''ServiceBuildingAppealPoint

tableContext :: TableContext ServiceBuildingAppealPoint
tableContext = TableContext
    serviceBuildingAppealPoint
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_appeal_point"
    "sb_id"
    fields
    NoParam
