{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbEmergencyResponse where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_emergency_response"
deriveJSON defaultOptions ''RelSbEmergencyResponse
mkFields ''RelSbEmergencyResponse

tableContext :: TableContext RelSbEmergencyResponse
tableContext = TableContext
    relSbEmergencyResponse
    sbId
    sbId'
    "rel_sb_emergency_response"
    "sb_id"
    fields
    NoParam
