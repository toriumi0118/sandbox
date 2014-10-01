{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbBathBathType where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_bath_bath_type"
deriveJSON defaultOptions ''RelSbBathBathType
mkFields ''RelSbBathBathType

tableContext :: TableContext RelSbBathBathType
tableContext = TableContext
    relSbBathBathType
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_bath_bath_type"
    "sb_id"
    fields
    NoParam
