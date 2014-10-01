{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbOuterFacility where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_outer_facility"
deriveJSON defaultOptions ''RelSbOuterFacility
mkFields ''RelSbOuterFacility

tableContext :: TableContext RelSbOuterFacility
tableContext = TableContext
    relSbOuterFacility
    sbId
    sbId'
    "rel_sb_outer_facility"
    "sb_id"
    fields
    NoParam
