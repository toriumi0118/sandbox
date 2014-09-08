
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathOnsen where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_onsen"
deriveJSON defaultOptions ''RelBathOnsen
mkFields ''RelBathOnsen

tableContext :: TableContext
tableContext = TableContext
    relBathOnsen
    officeId
    officeId'
    "rel_bath_onsen"
    "office_id"
    fields
