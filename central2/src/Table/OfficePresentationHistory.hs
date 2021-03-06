{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePresentationHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_presentation_history"

deriveJSON defaultOptions ''OfficePresentationHistory

historyContext :: HistoryContext OfficePresentationHistory
historyContext = HistoryContext
    officePresentationHistory
    id'
    V.officePresentationId
    (\h -> History (id h) (officeId h) Nothing (read $ action h) Nothing Nothing)
