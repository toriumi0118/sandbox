{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeImageHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "office_image_history"

deriveJSON defaultOptions ''OfficeImageHistory

instance History OfficeImageHistory

historyContext :: HistoryContext OfficeImageHistory
historyContext = HistoryContext
    officeImageHistory
    id'
    V.officeImageId
