
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealBreakfast where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_breakfast"
deriveJSON defaultOptions ''RelMealBreakfast
mkFields ''RelMealBreakfast

tableContext :: TableContext
tableContext = TableContext
    relMealBreakfast
    officeId
    officeId'
    "rel_meal_breakfast"
    "office_id"
    fields
