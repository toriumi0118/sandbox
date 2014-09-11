{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelTerminalCare where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_terminal_care"
deriveJSON defaultOptions ''RelTerminalCare
mkFields ''RelTerminalCare

tableContext :: TableContext RelTerminalCare
tableContext = TableContext
    relTerminalCare
    officeId
    officeId'
    "rel_terminal_care"
    "office_id"
    fields
    Nothing
