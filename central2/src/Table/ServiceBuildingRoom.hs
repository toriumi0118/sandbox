{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRoom where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_room"
deriveJSON defaultOptions ''ServiceBuildingRoom
mkFields ''ServiceBuildingRoom

tableContext :: TableContext ServiceBuildingRoom
tableContext = TableContext
    serviceBuildingRoom
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_room"
    "sb_id"
    fields
    NoParam
