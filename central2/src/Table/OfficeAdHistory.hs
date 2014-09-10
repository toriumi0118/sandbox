{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeAdHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "office_ad_history"

deriveJSON defaultOptions ''OfficeAdHistory

instance History OfficeAdHistory

historyContext :: HistoryContext OfficeAdHistory
historyContext = HistoryContext
    officeAdHistory
    id'
    V.officeAdId
