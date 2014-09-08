
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaAddFee where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_add_fee"
deriveJSON defaultOptions ''RelDementiaAddFee
mkFields ''RelDementiaAddFee

tableContext :: TableContext
tableContext = TableContext
    relDementiaAddFee
    officeId
    officeId'
    "rel_dementia_add_fee"
    "office_id"
    fields
