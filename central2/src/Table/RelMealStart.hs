
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealStart where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_start"
deriveJSON defaultOptions ''RelMealStart
mkFields ''RelMealStart

tableContext :: TableContext
tableContext = TableContext
    relMealStart
    officeId
    officeId'
    "rel_meal_start"
    "office_id"
    fields
