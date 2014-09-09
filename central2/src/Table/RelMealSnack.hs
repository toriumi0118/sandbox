
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealSnack where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_snack"
deriveJSON defaultOptions ''RelMealSnack
mkFields ''RelMealSnack

tableContext :: TableContext RelMealSnack
tableContext = TableContext
    relMealSnack
    officeId
    officeId'
    "rel_meal_snack"
    "office_id"
    fields
