{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMealMealType where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_meal_meal_type"
deriveJSON defaultOptions ''RelSbMealMealType
mkFields ''RelSbMealMealType

tableContext :: TableContext RelSbMealMealType
tableContext = TableContext
    relSbMealMealType
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_meal_meal_type"
    "sb_id"
    fields
    NoParam
