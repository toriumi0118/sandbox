
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealMenu where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_menu"
deriveJSON defaultOptions ''RelMealMenu
mkFields ''RelMealMenu

tableContext :: TableContext RelMealMenu
tableContext = TableContext
    relMealMenu
    officeId
    officeId'
    "rel_meal_menu"
    "office_id"
    fields
