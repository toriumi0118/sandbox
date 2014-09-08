
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDesign where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_design"
deriveJSON defaultOptions ''RelDesign
mkFields ''RelDesign

tableContext :: TableContext
tableContext = TableContext
    relDesign
    officeId
    officeId'
    "rel_design"
    "office_id"
    fields
