{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelatedOfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "related_office_history"

deriveJSON defaultOptions ''RelatedOfficeHistory

historyContext :: HistoryContext RelatedOfficeHistory
historyContext = HistoryContext
    relatedOfficeHistory
    id'
    V.relatedOfficeId
    (\h -> History (id h) (relatedOfficeId h) (Just $ relatedOfficeId h) (read $ action h) Nothing Nothing)
