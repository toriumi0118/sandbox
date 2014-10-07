{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHealthMachine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_health_machine"
deriveJSON defaultOptions ''RelHealthMachine
mkFields ''RelHealthMachine

tableContext :: TableContext RelHealthMachine
tableContext = TableContext
    relHealthMachine
    officeId
    officeId'
    "rel_health_machine"
    "office_id"
    fields
    NoParam
