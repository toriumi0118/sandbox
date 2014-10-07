{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingInfectionsDetail where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_infections_detail"
deriveJSON defaultOptions ''ServiceBuildingInfectionsDetail
mkFields ''ServiceBuildingInfectionsDetail

tableContext :: TableContext ServiceBuildingInfectionsDetail
tableContext = TableContext
    serviceBuildingInfectionsDetail
    sbId
    sbId'
    "service_building_infections_detail"
    "sb_id"
    fields
    NoParam
