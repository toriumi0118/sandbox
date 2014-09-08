
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelInfoDiscovery where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_info_discovery"
deriveJSON defaultOptions ''RelInfoDiscovery
mkFields ''RelInfoDiscovery

tableContext :: TableContext
tableContext = TableContext
    relInfoDiscovery
    officeId
    officeId'
    "rel_info_discovery"
    "office_id"
    fields
