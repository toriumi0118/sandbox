{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMimamoriProvideHours where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_mimamori_provide_hours"
deriveJSON defaultOptions ''RelSbMimamoriProvideHours
mkFields ''RelSbMimamoriProvideHours

tableContext :: TableContext RelSbMimamoriProvideHours
tableContext = TableContext
    relSbMimamoriProvideHours
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_mimamori_provide_hours"
    "sb_id"
    fields
    NoParam
