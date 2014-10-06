{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingImageHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "service_building_image_history"

deriveJSON defaultOptions ''ServiceBuildingImageHistory

historyContext :: HistoryContext ServiceBuildingImageHistory
historyContext = HistoryContext
    serviceBuildingImageHistory
    id'
    V.serviceBuildingImgId
    (\h -> History (id h) (sbId h) Nothing (read $ action h) (Just $ fileName h) Nothing)
