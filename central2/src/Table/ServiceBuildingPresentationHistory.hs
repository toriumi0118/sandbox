{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingPresentationHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "service_building_presentation_history"

deriveJSON defaultOptions ''ServiceBuildingPresentationHistory

historyContext :: HistoryContext ServiceBuildingPresentationHistory
historyContext = HistoryContext
    serviceBuildingPresentationHistory
    id'
    V.serviceBuildingPresentationId
    (\h -> History (id h) (sbId h) Nothing (read $ action h) Nothing Nothing)
