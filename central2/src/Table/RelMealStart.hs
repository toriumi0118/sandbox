{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealStart where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_start"
deriveJSON defaultOptions ''RelMealStart
mkFields ''RelMealStart

tableContext :: TableContext RelMealStart
tableContext = TableContext
    relMealStart
    officeId
    officeId'
    "rel_meal_start"
    "office_id"
    fields
    Nothing
