{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMimamoriEmergencyCallMethod where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_mimamori_emergency_call_method"
deriveJSON defaultOptions ''RelSbMimamoriEmergencyCallMethod
mkFields ''RelSbMimamoriEmergencyCallMethod

tableContext :: TableContext RelSbMimamoriEmergencyCallMethod
tableContext = TableContext
    relSbMimamoriEmergencyCallMethod
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_mimamori_emergency_call_method"
    "sb_id"
    fields
    NoParam
