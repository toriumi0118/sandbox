
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealDinner where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_dinner"
deriveJSON defaultOptions ''RelMealDinner
mkFields ''RelMealDinner

tableContext :: TableContext RelMealDinner
tableContext = TableContext
    relMealDinner
    officeId
    officeId'
    "rel_meal_dinner"
    "office_id"
    fields
