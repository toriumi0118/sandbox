{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePresentationHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
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
    (\h -> History |$| h ! id' |*| h ! officeId' |*| (read |$| h ! action'))
