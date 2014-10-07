{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathMachine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_bath_machine"
deriveJSON defaultOptions ''RelBathMachine
mkFields ''RelBathMachine

tableContext :: TableContext RelBathMachine
tableContext = TableContext
    relBathMachine
    officeId
    officeId'
    "rel_bath_machine"
    "office_id"
    fields
    NoParam
