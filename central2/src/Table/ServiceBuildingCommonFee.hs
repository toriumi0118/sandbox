{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingCommonFee where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_common_fee"
deriveJSON defaultOptions ''ServiceBuildingCommonFee
mkFields ''ServiceBuildingCommonFee

tableContext :: TableContext ServiceBuildingCommonFee
tableContext = TableContext
    serviceBuildingCommonFee
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_common_fee"
    "sb_id"
    fields
    NoParam
