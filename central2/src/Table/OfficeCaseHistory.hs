{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeCaseHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
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
    (\h -> History (id h) (officeId h) (Just $ officePdfId h) (read $ action h) (Just $ fileName h) Nothing)
