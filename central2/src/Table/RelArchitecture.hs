
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelArchitecture where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_architecture"
deriveJSON defaultOptions ''RelArchitecture
mkFields ''RelArchitecture

tableContext :: TableContext
tableContext = TableContext
    relArchitecture
    officeId
    officeId'
    "rel_architecture"
    "office_id"
    fields
