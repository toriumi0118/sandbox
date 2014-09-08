
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealSnack where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_snack"
deriveJSON defaultOptions ''RelMealSnack
mkFields ''RelMealSnack

tableContext :: TableContext
tableContext = TableContext
    relMealSnack
    officeId
    officeId'
    "rel_meal_snack"
    "office_id"
    fields
