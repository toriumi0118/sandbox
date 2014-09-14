{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.KyotakuHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "kyotaku_history"

deriveJSON defaultOptions ''KyotakuHistory

instance History KyotakuHistory

historyContext :: HistoryContext KyotakuHistory
historyContext = HistoryContext
    kyotakuHistory
    id'
    V.kyotakuId
