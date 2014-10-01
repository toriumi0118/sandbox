{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSrvPrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_srv_price"
deriveJSON defaultOptions ''RelSrvPrice
mkFields ''RelSrvPrice

tableContext :: TableContext RelSrvPrice
tableContext = TableContext
    relSrvPrice
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_srv_price"
    "sb_id"
    fields
    NoParam
