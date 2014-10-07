{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingEnv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_env"
deriveJSON defaultOptions ''ServiceBuildingEnv
mkFields ''ServiceBuildingEnv

tableContext :: TableContext ServiceBuildingEnv
tableContext = TableContext
    serviceBuildingEnv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_env"
    "sb_id"
    fields
    NoParam
