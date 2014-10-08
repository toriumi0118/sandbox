{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingShortStay where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_short_stay"
deriveJSON defaultOptions ''ServiceBuildingShortStay
mkFields ''ServiceBuildingShortStay

tableContext :: TableContext ServiceBuildingShortStay
tableContext = TableContext
    serviceBuildingShortStay
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_short_stay"
    "sb_id"
    fields
    NoParam
