
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAlcohol where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_alcohol"
deriveJSON defaultOptions ''RelAlcohol
mkFields ''RelAlcohol

tableContext :: TableContext
tableContext = TableContext
    relAlcohol
    officeId
    officeId'
    "rel_alcohol"
    "office_id"
    fields
