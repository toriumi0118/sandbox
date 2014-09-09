
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSingleCare where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_single_care"
deriveJSON defaultOptions ''RelSingleCare
mkFields ''RelSingleCare

tableContext :: TableContext RelSingleCare
tableContext = TableContext
    relSingleCare
    officeId
    officeId'
    "rel_single_care"
    "office_id"
    fields
