{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbInfections where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_infections"
deriveJSON defaultOptions ''RelSbInfections
mkFields ''RelSbInfections

tableContext :: TableContext RelSbInfections
tableContext = TableContext
    relSbInfections
    sbId
    sbId'
    "rel_sb_infections"
    "sb_id"
    fields
    NoParam
