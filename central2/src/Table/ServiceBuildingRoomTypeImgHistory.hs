{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRoomTypeImgHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Json ()
import DataSource (defineTable)

defineTable "service_building_room_type_img_history"

deriveJSON defaultOptions ''ServiceBuildingRoomTypeImgHistory
