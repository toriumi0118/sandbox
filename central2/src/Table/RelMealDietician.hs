
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealDietician where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_dietician"
deriveJSON defaultOptions ''RelMealDietician
mkFields ''RelMealDietician

tableContext :: TableContext RelMealDietician
tableContext = TableContext
    relMealDietician
    officeId
    officeId'
    "rel_meal_dietician"
    "office_id"
    fields
