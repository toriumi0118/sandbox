{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRoomTypeImg where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_room_type_img"
deriveJSON defaultOptions ''ServiceBuildingRoomTypeImg
mkFields ''ServiceBuildingRoomTypeImg

tableContext :: TableContext ServiceBuildingRoomTypeImg
tableContext = TableContext
    serviceBuildingRoomTypeImg
    (fromIntegral . id)
    (fromIntegral |$| id')
    "service_building_room_type_img"
    "id"
    fields
    NoParam
