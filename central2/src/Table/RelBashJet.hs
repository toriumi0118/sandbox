
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBashJet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bash_jet"
deriveJSON defaultOptions ''RelBashJet
mkFields ''RelBashJet

tableContext :: TableContext
tableContext = TableContext
    relBashJet
    officeId
    officeId'
    "rel_bash_jet"
    "office_id"
    fields
