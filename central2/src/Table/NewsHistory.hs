{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "news_history"

deriveJSON defaultOptions ''NewsHistory

instance History NewsHistory

historyContext :: HistoryContext NewsHistory
historyContext = HistoryContext
    newsHistory
    id'
    V.newsHeadId
