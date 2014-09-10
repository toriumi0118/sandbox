{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "office_history"

deriveJSON defaultOptions ''OfficeHistory

instance Eq OfficeHistory where
    a == b = officeId a == officeId b

instance Ord OfficeHistory where
    a <= b = officeId a <= officeId b

instance History OfficeHistory

historyContext :: HistoryContext OfficeHistory
historyContext = HistoryContext
    officeHistory
    id'
    V.officeId
