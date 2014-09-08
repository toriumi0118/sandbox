
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelWithPet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_with_pet"
deriveJSON defaultOptions ''RelWithPet
mkFields ''RelWithPet

tableContext :: TableContext
tableContext = TableContext
    relWithPet
    officeId
    officeId'
    "rel_with_pet"
    "office_id"
    fields
