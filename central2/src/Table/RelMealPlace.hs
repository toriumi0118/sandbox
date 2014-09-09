
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealPlace where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_place"
deriveJSON defaultOptions ''RelMealPlace
mkFields ''RelMealPlace

tableContext :: TableContext RelMealPlace
tableContext = TableContext
    relMealPlace
    officeId
    officeId'
    "rel_meal_place"
    "office_id"
    fields
