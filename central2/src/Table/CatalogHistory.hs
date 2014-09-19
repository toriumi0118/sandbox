{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.CatalogHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "catalog_history"

deriveJSON defaultOptions ''CatalogHistory

historyContext :: HistoryContext CatalogHistory
historyContext = HistoryContext
    catalogHistory
    id'
    V.catalogId
    (\h -> History |$| h ! id' |*| h ! catalogId' |*| (read |$| h ! action'))
