{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbTrial where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_trial"
deriveJSON defaultOptions ''RelSbTrial
mkFields ''RelSbTrial

tableContext :: TableContext RelSbTrial
tableContext = TableContext
    relSbTrial
    sbId
    sbId'
    "rel_sb_trial"
    "sb_id"
    fields
    NoParam
