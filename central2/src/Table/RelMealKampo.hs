
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealKampo where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_kampo"
deriveJSON defaultOptions ''RelMealKampo
mkFields ''RelMealKampo

tableContext :: TableContext
tableContext = TableContext
    relMealKampo
    officeId
    officeId'
    "rel_meal_kampo"
    "office_id"
    fields
