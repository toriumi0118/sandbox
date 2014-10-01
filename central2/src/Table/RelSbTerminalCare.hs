{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbTerminalCare where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_terminal_care"
deriveJSON defaultOptions ''RelSbTerminalCare
mkFields ''RelSbTerminalCare

tableContext :: TableContext RelSbTerminalCare
tableContext = TableContext
    relSbTerminalCare
    sbId
    sbId'
    "rel_sb_terminal_care"
    "sb_id"
    fields
    NoParam
