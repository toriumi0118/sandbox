
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathMachine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_machine"
deriveJSON defaultOptions ''RelBathMachine
mkFields ''RelBathMachine

tableContext :: TableContext
tableContext = TableContext
    relBathMachine
    officeId
    officeId'
    "rel_bath_machine"
    "office_id"
    fields
