{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.SbAdHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "sb_ad_history"

deriveJSON defaultOptions ''SbAdHistory

historyContext :: HistoryContext SbAdHistory
historyContext = HistoryContext
    sbAdHistory
    id'
    V.sbAdId
    (\h -> History (id h) (officeId h) (Just $ officePdfId h) (read $ action h) (Just $ fileName h) Nothing)
