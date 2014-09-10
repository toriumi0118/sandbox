{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeCaseHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "office_case_history"

deriveJSON defaultOptions ''OfficeCaseHistory

instance History OfficeCaseHistory

historyContext :: HistoryContext OfficeCaseHistory
historyContext = HistoryContext
    officeCaseHistory
    id'
    V.officeCaseId
