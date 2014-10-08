{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbKeepHealthMedical where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_keep_health_medical"
deriveJSON defaultOptions ''RelSbKeepHealthMedical
mkFields ''RelSbKeepHealthMedical

tableContext :: TableContext RelSbKeepHealthMedical
tableContext = TableContext
    relSbKeepHealthMedical
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_keep_health_medical"
    "sb_id"
    fields
    NoParam
