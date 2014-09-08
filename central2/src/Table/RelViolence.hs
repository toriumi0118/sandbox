
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelViolence where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_violence"
deriveJSON defaultOptions ''RelViolence
mkFields ''RelViolence

tableContext :: TableContext
tableContext = TableContext
    relViolence
    officeId
    officeId'
    "rel_violence"
    "office_id"
    fields
