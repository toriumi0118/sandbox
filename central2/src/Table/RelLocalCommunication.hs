
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelLocalCommunication where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_local_communication"
deriveJSON defaultOptions ''RelLocalCommunication
mkFields ''RelLocalCommunication

tableContext :: TableContext
tableContext = TableContext
    relLocalCommunication
    officeId
    officeId'
    "rel_local_communication"
    "office_id"
    fields
