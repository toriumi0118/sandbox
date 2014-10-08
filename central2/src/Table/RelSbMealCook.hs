{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMealCook where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_meal_cook"
deriveJSON defaultOptions ''RelSbMealCook
mkFields ''RelSbMealCook

tableContext :: TableContext RelSbMealCook
tableContext = TableContext
    relSbMealCook
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_meal_cook"
    "sb_id"
    fields
    NoParam
