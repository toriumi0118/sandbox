{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMimamoriStaff where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_mimamori_staff"
deriveJSON defaultOptions ''RelSbMimamoriStaff
mkFields ''RelSbMimamoriStaff

tableContext :: TableContext RelSbMimamoriStaff
tableContext = TableContext
    relSbMimamoriStaff
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_mimamori_staff"
    "sb_id"
    fields
    NoParam
