{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRoomType where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_room_type"
deriveJSON defaultOptions ''ServiceBuildingRoomType
mkFields ''ServiceBuildingRoomType

tableContext :: TableContext ServiceBuildingRoomType
tableContext = TableContext
    serviceBuildingRoomType
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_room_type"
    "sb_id"
    fields
    NoParam
