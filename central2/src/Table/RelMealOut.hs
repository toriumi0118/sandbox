
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealOut where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_out"
deriveJSON defaultOptions ''RelMealOut
mkFields ''RelMealOut

tableContext :: TableContext
tableContext = TableContext
    relMealOut
    officeId
    officeId'
    "rel_meal_out"
    "office_id"
    fields
