
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDriveTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_drive_time"
deriveJSON defaultOptions ''RelDriveTime
mkFields ''RelDriveTime

tableContext :: TableContext
tableContext = TableContext
    relDriveTime
    officeId
    officeId'
    "rel_drive_time"
    "office_id"
    fields
