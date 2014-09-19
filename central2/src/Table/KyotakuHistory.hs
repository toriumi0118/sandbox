{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.KyotakuHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "kyotaku_history"

deriveJSON defaultOptions ''KyotakuHistory

historyContext :: HistoryContext KyotakuHistory
historyContext = HistoryContext
    kyotakuHistory
    id'
    V.kyotakuId
    (\h -> History |$| h ! id' |*| h ! officeId' |*| (read |$| h ! action'))
