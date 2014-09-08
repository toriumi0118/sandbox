
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelOrientalMedicine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_oriental_medicine"
deriveJSON defaultOptions ''RelOrientalMedicine
mkFields ''RelOrientalMedicine

tableContext :: TableContext
tableContext = TableContext
    relOrientalMedicine
    officeId
    officeId'
    "rel_oriental_medicine"
    "office_id"
    fields
