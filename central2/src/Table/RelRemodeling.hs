
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelRemodeling where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_remodeling"
deriveJSON defaultOptions ''RelRemodeling
mkFields ''RelRemodeling

tableContext :: TableContext
tableContext = TableContext
    relRemodeling
    officeId
    officeId'
    "rel_remodeling"
    "office_id"
    fields
