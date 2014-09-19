{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeAdHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_ad_history"

deriveJSON defaultOptions ''OfficeAdHistory

historyContext :: HistoryContext OfficeAdHistory
historyContext = HistoryContext
    officeAdHistory
    id'
    V.officeAdId
    (\h -> History |$| h ! id' |*| h ! officeId' |*| (read |$| h ! action'))
