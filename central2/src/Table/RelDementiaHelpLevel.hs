
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaHelpLevel where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_help_level"
deriveJSON defaultOptions ''RelDementiaHelpLevel
mkFields ''RelDementiaHelpLevel

tableContext :: TableContext
tableContext = TableContext
    relDementiaHelpLevel
    officeId
    officeId'
    "rel_dementia_help_level"
    "office_id"
    fields
