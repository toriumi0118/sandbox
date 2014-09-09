
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealLaunch where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_launch"
deriveJSON defaultOptions ''RelMealLaunch
mkFields ''RelMealLaunch

tableContext :: TableContext RelMealLaunch
tableContext = TableContext
    relMealLaunch
    officeId
    officeId'
    "rel_meal_launch"
    "office_id"
    fields
