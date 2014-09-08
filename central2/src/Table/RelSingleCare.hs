
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSingleCare where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_single_care"
deriveJSON defaultOptions ''RelSingleCare
mkFields ''RelSingleCare

tableContext :: TableContext
tableContext = TableContext
    relSingleCare
    officeId
    officeId'
    "rel_single_care"
    "office_id"
    fields
