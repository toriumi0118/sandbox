{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.TopicHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(DirHistory))
import DataSource (defineTable)

defineTable "topic_history"

deriveJSON defaultOptions ''TopicHistory

historyContext :: HistoryContext TopicHistory
historyContext = HistoryContext
    topicHistory
    id'
    V.topicId
    (\h -> DirHistory |$| h ! id' |*| h ! topicId' |*| (read |$| h ! action') |*| h ! topicDir')
