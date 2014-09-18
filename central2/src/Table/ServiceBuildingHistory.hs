{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "service_building_history"

deriveJSON defaultOptions ''ServiceBuildingHistory

historyContext :: HistoryContext ServiceBuildingHistory
historyContext = HistoryContext
    serviceBuildingHistory
    id'
    V.serviceBuildingId
    (\h -> History |$| h ! sbId' |*| (read |$| h ! action'))
