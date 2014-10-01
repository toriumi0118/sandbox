{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMimamoriProvideDays where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_mimamori_provide_days"
deriveJSON defaultOptions ''RelSbMimamoriProvideDays
mkFields ''RelSbMimamoriProvideDays

tableContext :: TableContext RelSbMimamoriProvideDays
tableContext = TableContext
    relSbMimamoriProvideDays
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_mimamori_provide_days"
    "sb_id"
    fields
    NoParam
