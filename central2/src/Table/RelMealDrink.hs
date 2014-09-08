
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealDrink where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_drink"
deriveJSON defaultOptions ''RelMealDrink
mkFields ''RelMealDrink

tableContext :: TableContext
tableContext = TableContext
    relMealDrink
    officeId
    officeId'
    "rel_meal_drink"
    "office_id"
    fields
