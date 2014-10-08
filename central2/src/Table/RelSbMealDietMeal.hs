{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMealDietMeal where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_meal_diet_meal"
deriveJSON defaultOptions ''RelSbMealDietMeal
mkFields ''RelSbMealDietMeal

tableContext :: TableContext RelSbMealDietMeal
tableContext = TableContext
    relSbMealDietMeal
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_meal_diet_meal"
    "sb_id"
    fields
    NoParam
