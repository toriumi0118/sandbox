
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelPet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_pet"
deriveJSON defaultOptions ''RelPet
mkFields ''RelPet

tableContext :: TableContext
tableContext = TableContext
    relPet
    officeId
    officeId'
    "rel_pet"
    "office_id"
    fields
