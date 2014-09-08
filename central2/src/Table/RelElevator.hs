
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelElevator where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_elevator"
deriveJSON defaultOptions ''RelElevator
mkFields ''RelElevator

tableContext :: TableContext
tableContext = TableContext
    relElevator
    officeId
    officeId'
    "rel_elevator"
    "office_id"
    fields
