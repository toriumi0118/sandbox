
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealDinner where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_dinner"
deriveJSON defaultOptions ''RelMealDinner
mkFields ''RelMealDinner

tableContext :: TableContext
tableContext = TableContext
    relMealDinner
    officeId
    officeId'
    "rel_meal_dinner"
    "office_id"
    fields
