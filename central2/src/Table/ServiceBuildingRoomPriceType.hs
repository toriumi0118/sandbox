{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRoomPriceType where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_room_price_type"
deriveJSON defaultOptions ''ServiceBuildingRoomPriceType
mkFields ''ServiceBuildingRoomPriceType

tableContext :: TableContext ServiceBuildingRoomPriceType
tableContext = TableContext
    serviceBuildingRoomPriceType
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_room_price_type"
    "sb_id"
    fields
    NoParam
