
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathType where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_type"
deriveJSON defaultOptions ''RelBathType
mkFields ''RelBathType

tableContext :: TableContext
tableContext = TableContext
    relBathType
    officeId
    officeId'
    "rel_bath_type"
    "office_id"
    fields
