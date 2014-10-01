{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbDetail where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_detail"
deriveJSON defaultOptions ''RelSbDetail
mkFields ''RelSbDetail

tableContext :: TableContext RelSbDetail
tableContext = TableContext
    relSbDetail
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_detail"
    "sb_id"
    fields
    NoParam
