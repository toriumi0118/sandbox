
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelRehabMachine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_rehab_machine"
deriveJSON defaultOptions ''RelRehabMachine
mkFields ''RelRehabMachine

tableContext :: TableContext
tableContext = TableContext
    relRehabMachine
    officeId
    officeId'
    "rel_rehab_machine"
    "office_id"
    fields
