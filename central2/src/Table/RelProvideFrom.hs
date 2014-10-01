{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelProvideFrom where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_provide_from"
deriveJSON defaultOptions ''RelProvideFrom
mkFields ''RelProvideFrom

tableContext :: TableContext RelProvideFrom
tableContext = TableContext
    relProvideFrom
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_provide_from"
    "sb_id"
    fields
    NoParam
