
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealDrink where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_drink"
deriveJSON defaultOptions ''RelMealDrink
mkFields ''RelMealDrink

tableContext :: TableContext RelMealDrink
tableContext = TableContext
    relMealDrink
    officeId
    officeId'
    "rel_meal_drink"
    "office_id"
    fields
