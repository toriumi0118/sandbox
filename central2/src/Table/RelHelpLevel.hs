
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHelpLevel where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_help_level"
deriveJSON defaultOptions ''RelHelpLevel
mkFields ''RelHelpLevel

tableContext :: TableContext
tableContext = TableContext
    relHelpLevel
    officeId
    officeId'
    "rel_help_level"
    "office_id"
    fields
