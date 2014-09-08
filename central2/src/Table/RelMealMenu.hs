
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealMenu where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_menu"
deriveJSON defaultOptions ''RelMealMenu
mkFields ''RelMealMenu

tableContext :: TableContext
tableContext = TableContext
    relMealMenu
    officeId
    officeId'
    "rel_meal_menu"
    "office_id"
    fields
