{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbInnerFacility where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_inner_facility"
deriveJSON defaultOptions ''RelSbInnerFacility
mkFields ''RelSbInnerFacility

tableContext :: TableContext RelSbInnerFacility
tableContext = TableContext
    relSbInnerFacility
    sbId
    sbId'
    "rel_sb_inner_facility"
    "sb_id"
    fields
    NoParam
