{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDriveRange where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_drive_range"
deriveJSON defaultOptions ''RelDriveRange
mkFields ''RelDriveRange

tableContext :: TableContext RelDriveRange
tableContext = TableContext
    relDriveRange
    officeId
    officeId'
    "rel_drive_range"
    "office_id"
    fields
    NoParam
