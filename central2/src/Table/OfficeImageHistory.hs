{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeImageHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "office_image_history"

deriveJSON defaultOptions ''OfficeImageHistory

historyContext :: HistoryContext OfficeImageHistory
historyContext = HistoryContext
    officeImageHistory
    id'
    V.officeImageId
    (\h -> History (id h) (officeId h) Nothing (read $ action h) (Just $ fileName h) Nothing)
