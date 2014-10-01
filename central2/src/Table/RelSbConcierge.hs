{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbConcierge where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_concierge"
deriveJSON defaultOptions ''RelSbConcierge
mkFields ''RelSbConcierge

tableContext :: TableContext RelSbConcierge
tableContext = TableContext
    relSbConcierge
    sbId
    sbId'
    "rel_sb_concierge"
    "sb_id"
    fields
    NoParam
