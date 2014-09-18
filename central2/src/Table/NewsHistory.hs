{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "news_history"

deriveJSON defaultOptions ''NewsHistory

historyContext :: HistoryContext NewsHistory
historyContext = HistoryContext
    newsHistory
    id'
    V.newsHeadId
    (\h -> History |$| h ! newsHeadId' |*| (read |$| h ! action'))
