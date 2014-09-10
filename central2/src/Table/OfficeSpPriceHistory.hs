{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeSpPriceHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "office_sp_price_history"

deriveJSON defaultOptions ''OfficeSpPriceHistory

instance History OfficeSpPriceHistory

historyContext :: HistoryContext OfficeSpPriceHistory
historyContext = HistoryContext
    officeSpPriceHistory
    id'
    V.officeSpPriceId
