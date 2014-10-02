{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.TopicHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "topic_history"

deriveJSON defaultOptions ''TopicHistory

historyContext :: HistoryContext TopicHistory
historyContext = HistoryContext
    topicHistory
    id'
    V.topicId
    (\h -> History (id h) (topicId h) (Just $ topicId h) (read $ action h) Nothing (topicDir h))
