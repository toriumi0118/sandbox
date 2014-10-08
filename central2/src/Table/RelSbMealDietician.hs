{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMealDietician where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_meal_dietician"
deriveJSON defaultOptions ''RelSbMealDietician
mkFields ''RelSbMealDietician

tableContext :: TableContext RelSbMealDietician
tableContext = TableContext
    relSbMealDietician
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_meal_dietician"
    "sb_id"
    fields
    NoParam
