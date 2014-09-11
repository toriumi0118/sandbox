{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.TopicHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "topic_history"

deriveJSON defaultOptions ''TopicHistory

instance History TopicHistory

historyContext :: HistoryContext TopicHistory
historyContext = HistoryContext
    topicHistory
    id'
    V.topicId
