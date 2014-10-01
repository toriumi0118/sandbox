{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbWander where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_wander"
deriveJSON defaultOptions ''RelSbWander
mkFields ''RelSbWander

tableContext :: TableContext RelSbWander
tableContext = TableContext
    relSbWander
    sbId
    sbId'
    "rel_sb_wander"
    "sb_id"
    fields
    NoParam
