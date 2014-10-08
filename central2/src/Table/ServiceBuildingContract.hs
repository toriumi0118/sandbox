{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingContract where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_contract"
deriveJSON defaultOptions ''ServiceBuildingContract
mkFields ''ServiceBuildingContract

tableContext :: TableContext ServiceBuildingContract
tableContext = TableContext
    serviceBuildingContract
    sbId
    sbId'
    "service_building_contract"
    "sb_id"
    fields
    NoParam
