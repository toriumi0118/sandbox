{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.CatalogHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
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
    (\h -> History (id h) (catalogId h) (Just $ catalogId h) (read $ action h) (Just $ filePath h) Nothing)
