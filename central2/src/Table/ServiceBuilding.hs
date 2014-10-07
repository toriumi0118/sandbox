{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuilding where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building"
deriveJSON defaultOptions ''ServiceBuilding
mkFields ''ServiceBuilding

tableContext :: TableContext ServiceBuilding
tableContext = TableContext
    serviceBuilding
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building"
    "sb_id"
    fields
    NoParam
