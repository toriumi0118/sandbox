
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelWithBuilding where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_with_building"
deriveJSON defaultOptions ''RelWithBuilding
mkFields ''RelWithBuilding

tableContext :: TableContext
tableContext = TableContext
    relWithBuilding
    officeId
    officeId'
    "rel_with_building"
    "office_id"
    fields
