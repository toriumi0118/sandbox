{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMimamoriEmergencyCallPlace where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_mimamori_emergency_call_place"
deriveJSON defaultOptions ''RelSbMimamoriEmergencyCallPlace
mkFields ''RelSbMimamoriEmergencyCallPlace

tableContext :: TableContext RelSbMimamoriEmergencyCallPlace
tableContext = TableContext
    relSbMimamoriEmergencyCallPlace
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_mimamori_emergency_call_place"
    "sb_id"
    fields
    NoParam
