{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_history"

deriveJSON defaultOptions ''OfficeHistory

historyContext :: HistoryContext OfficeHistory
historyContext = HistoryContext
    officeHistory
    id'
    V.officeId
    (\h -> History (id h) (officeId h) (Just $ officeId h) (read $ action h) Nothing Nothing)
