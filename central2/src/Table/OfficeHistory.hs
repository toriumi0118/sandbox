{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_history"

deriveJSON defaultOptions ''OfficeHistory

instance Eq OfficeHistory where
    a == b = officeId a == officeId b

instance Ord OfficeHistory where
    a <= b = officeId a <= officeId b

historyContext :: HistoryContext OfficeHistory
historyContext = HistoryContext
    officeHistory
    id'
    V.officeId
    (\h -> History |$| h ! officeId' |*| (read |$| h ! action'))
