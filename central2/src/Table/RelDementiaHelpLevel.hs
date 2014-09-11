
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaHelpLevel where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_help_level"
deriveJSON defaultOptions ''RelDementiaHelpLevel
mkFields ''RelDementiaHelpLevel

tableContext :: TableContext RelDementiaHelpLevel
tableContext = TableContext
    relDementiaHelpLevel
    officeId
    officeId'
    "rel_dementia_help_level"
    "office_id"
    fields
    Nothing
