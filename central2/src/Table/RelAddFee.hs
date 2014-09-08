
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFee where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_add_fee"
deriveJSON defaultOptions ''RelAddFee
mkFields ''RelAddFee

tableContext :: TableContext
tableContext = TableContext
    relAddFee
    officeId
    officeId'
    "rel_add_fee"
    "office_id"
    fields
