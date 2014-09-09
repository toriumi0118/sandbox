
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAttendantBed where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_attendant_bed"
deriveJSON defaultOptions ''RelAttendantBed
mkFields ''RelAttendantBed

tableContext :: TableContext RelAttendantBed
tableContext = TableContext
    relAttendantBed
    officeId
    officeId'
    "rel_attendant_bed"
    "office_id"
    fields
