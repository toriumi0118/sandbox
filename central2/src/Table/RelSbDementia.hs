{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbDementia where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_dementia"
deriveJSON defaultOptions ''RelSbDementia
mkFields ''RelSbDementia

tableContext :: TableContext RelSbDementia
tableContext = TableContext
    relSbDementia
    sbId
    sbId'
    "rel_sb_dementia"
    "sb_id"
    fields
    NoParam
