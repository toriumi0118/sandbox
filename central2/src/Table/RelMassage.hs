
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMassage where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_massage"
deriveJSON defaultOptions ''RelMassage
mkFields ''RelMassage

tableContext :: TableContext
tableContext = TableContext
    relMassage
    officeId
    officeId'
    "rel_massage"
    "office_id"
    fields
