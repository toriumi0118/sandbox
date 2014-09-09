
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHelpLevel where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_help_level"
deriveJSON defaultOptions ''RelHelpLevel
mkFields ''RelHelpLevel

tableContext :: TableContext RelHelpLevel
tableContext = TableContext
    relHelpLevel
    officeId
    officeId'
    "rel_help_level"
    "office_id"
    fields
