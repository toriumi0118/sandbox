{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbKeepHealthRehab where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_keep_health_rehab"
deriveJSON defaultOptions ''RelSbKeepHealthRehab
mkFields ''RelSbKeepHealthRehab

tableContext :: TableContext RelSbKeepHealthRehab
tableContext = TableContext
    relSbKeepHealthRehab
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_keep_health_rehab"
    "sb_id"
    fields
    NoParam
