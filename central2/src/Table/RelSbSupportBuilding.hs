{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbSupportBuilding where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_support_building"
deriveJSON defaultOptions ''RelSbSupportBuilding
mkFields ''RelSbSupportBuilding

tableContext :: TableContext RelSbSupportBuilding
tableContext = TableContext
    relSbSupportBuilding
    sbId
    sbId'
    "rel_sb_support_building"
    "sb_id"
    fields
    NoParam
