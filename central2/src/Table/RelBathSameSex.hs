
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathSameSex where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_same_sex"
deriveJSON defaultOptions ''RelBathSameSex
mkFields ''RelBathSameSex

tableContext :: TableContext
tableContext = TableContext
    relBathSameSex
    officeId
    officeId'
    "rel_bath_same_sex"
    "office_id"
    fields
