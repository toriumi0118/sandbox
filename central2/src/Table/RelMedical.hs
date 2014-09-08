
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMedical where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_medical"
deriveJSON defaultOptions ''RelMedical
mkFields ''RelMedical

tableContext :: TableContext
tableContext = TableContext
    relMedical
    officeId
    officeId'
    "rel_medical"
    "office_id"
    fields
