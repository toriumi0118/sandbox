{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingRoomTypeImgHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "service_building_room_type_img_history"

deriveJSON defaultOptions ''ServiceBuildingRoomTypeImgHistory

historyContext :: HistoryContext ServiceBuildingRoomTypeImgHistory
historyContext = HistoryContext
    serviceBuildingRoomTypeImgHistory
    id'
    V.serviceBuildingRoomTypeImgId
    (\h -> History (id h) (sbId h) (Just $ roomTypeImgId h) (read $ action h) (Just $ fileName h) Nothing)
