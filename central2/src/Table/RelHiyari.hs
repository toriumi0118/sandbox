
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHiyari where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_hiyari"
deriveJSON defaultOptions ''RelHiyari
mkFields ''RelHiyari

tableContext :: TableContext
tableContext = TableContext
    relHiyari
    officeId
    officeId'
    "rel_hiyari"
    "office_id"
    fields
