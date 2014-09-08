
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaFloor where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_floor"
deriveJSON defaultOptions ''RelDementiaFloor
mkFields ''RelDementiaFloor

tableContext :: TableContext
tableContext = TableContext
    relDementiaFloor
    officeId
    officeId'
    "rel_dementia_floor"
    "office_id"
    fields
