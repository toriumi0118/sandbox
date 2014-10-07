{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelInfoDiscovery where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_info_discovery"
deriveJSON defaultOptions ''RelInfoDiscovery
mkFields ''RelInfoDiscovery

tableContext :: TableContext RelInfoDiscovery
tableContext = TableContext
    relInfoDiscovery
    officeId
    officeId'
    "rel_info_discovery"
    "office_id"
    fields
    NoParam
