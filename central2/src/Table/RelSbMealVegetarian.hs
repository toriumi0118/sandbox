{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMealVegetarian where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_meal_vegetarian"
deriveJSON defaultOptions ''RelSbMealVegetarian
mkFields ''RelSbMealVegetarian

tableContext :: TableContext RelSbMealVegetarian
tableContext = TableContext
    relSbMealVegetarian
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_meal_vegetarian"
    "sb_id"
    fields
    NoParam
