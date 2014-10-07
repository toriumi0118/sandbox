{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeSpPriceHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_sp_price_history"

deriveJSON defaultOptions ''OfficeSpPriceHistory

historyContext :: HistoryContext OfficeSpPriceHistory
historyContext = HistoryContext
    officeSpPriceHistory
    id'
    V.officeSpPriceId
    (\h -> History (id h) (officeId h) (Just $ officePdfId h) (read $ action h) (Just $ fileName h) Nothing)
