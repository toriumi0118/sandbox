{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
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
    (\h -> History (id h) (newsHeadId h) (Just $ newsHeadId h) (read $ action h) Nothing Nothing)
