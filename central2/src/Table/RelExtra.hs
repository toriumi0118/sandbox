
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelExtra where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_extra"
deriveJSON defaultOptions ''RelExtra
mkFields ''RelExtra

tableContext :: TableContext
tableContext = TableContext
    relExtra
    officeId
    officeId'
    "rel_extra"
    "office_id"
    fields
