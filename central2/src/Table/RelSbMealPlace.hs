{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbMealPlace where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_meal_place"
deriveJSON defaultOptions ''RelSbMealPlace
mkFields ''RelSbMealPlace

tableContext :: TableContext RelSbMealPlace
tableContext = TableContext
    relSbMealPlace
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_meal_place"
    "sb_id"
    fields
    NoParam
