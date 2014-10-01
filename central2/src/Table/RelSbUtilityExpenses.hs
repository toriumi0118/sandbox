{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbUtilityExpenses where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_utility_expenses"
deriveJSON defaultOptions ''RelSbUtilityExpenses
mkFields ''RelSbUtilityExpenses

tableContext :: TableContext RelSbUtilityExpenses
tableContext = TableContext
    relSbUtilityExpenses
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_utility_expenses"
    "sb_id"
    fields
    NoParam
