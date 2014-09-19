{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeImageHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query hiding (id')
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(FileHistory))
import DataSource (defineTable)

defineTable "office_image_history"

deriveJSON defaultOptions ''OfficeImageHistory

historyContext :: HistoryContext OfficeImageHistory
historyContext = HistoryContext
    officeImageHistory
    id'
    V.officeImageId
    (\h -> FileHistory |$| h ! id' |*| h ! officeId' |*| (read |$| h ! action') |*| h ! fileName')
