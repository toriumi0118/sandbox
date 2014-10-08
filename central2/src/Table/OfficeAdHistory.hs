{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeAdHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_ad_history"

deriveJSON defaultOptions ''OfficeAdHistory

historyContext :: HistoryContext OfficeAdHistory
historyContext = HistoryContext
    officeAdHistory
    id'
    V.officeAdId
    (\h -> History (id h) (officeId h) (Just $ officePdfId h) (read $ action h) (Just $ fileName h) Nothing)
