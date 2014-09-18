{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeCaseHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_case_history"

deriveJSON defaultOptions ''OfficeCaseHistory

historyContext :: HistoryContext OfficeCaseHistory
historyContext = HistoryContext
    officeCaseHistory
    id'
    V.officeCaseId
    (\h -> History |$| h ! officeId' |*| (read |$| h ! action'))

-- officePdfId
