
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDriveTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_drive_time"
deriveJSON defaultOptions ''RelDriveTime
mkFields ''RelDriveTime

tableContext :: TableContext RelDriveTime
tableContext = TableContext
    relDriveTime
    officeId
    officeId'
    "rel_drive_time"
    "office_id"
    fields
