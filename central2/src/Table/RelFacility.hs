
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFacility where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_facility"
deriveJSON defaultOptions ''RelFacility
mkFields ''RelFacility

tableContext :: TableContext RelFacility
tableContext = TableContext
    relFacility
    officeId
    officeId'
    "rel_facility"
    "office_id"
    fields
