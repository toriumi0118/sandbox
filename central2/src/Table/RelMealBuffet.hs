
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealBuffet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_buffet"
deriveJSON defaultOptions ''RelMealBuffet
mkFields ''RelMealBuffet

tableContext :: TableContext
tableContext = TableContext
    relMealBuffet
    officeId
    officeId'
    "rel_meal_buffet"
    "office_id"
    fields
