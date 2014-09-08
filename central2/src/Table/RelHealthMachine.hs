
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHealthMachine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_health_machine"
deriveJSON defaultOptions ''RelHealthMachine
mkFields ''RelHealthMachine

tableContext :: TableContext
tableContext = TableContext
    relHealthMachine
    officeId
    officeId'
    "rel_health_machine"
    "office_id"
    fields
