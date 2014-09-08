
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealDietician where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_dietician"
deriveJSON defaultOptions ''RelMealDietician
mkFields ''RelMealDietician

tableContext :: TableContext
tableContext = TableContext
    relMealDietician
    officeId
    officeId'
    "rel_meal_dietician"
    "office_id"
    fields
