{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingImageCom where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_building_image_com"
deriveJSON defaultOptions ''ServiceBuildingImageCom
mkFields ''ServiceBuildingImageCom

tableContext :: TableContext ServiceBuildingImageCom
tableContext = TableContext
    serviceBuildingImageCom
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "service_building_image_com"
    "sb_id"
    fields
    NoParam
