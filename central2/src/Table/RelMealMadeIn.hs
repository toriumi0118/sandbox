
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealMadeIn where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_made_in"
deriveJSON defaultOptions ''RelMealMadeIn
mkFields ''RelMealMadeIn

tableContext :: TableContext
tableContext = TableContext
    relMealMadeIn
    officeId
    officeId'
    "rel_meal_made_in"
    "office_id"
    fields
