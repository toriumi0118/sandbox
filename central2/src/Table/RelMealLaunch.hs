
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealLaunch where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_meal_launch"
deriveJSON defaultOptions ''RelMealLaunch
mkFields ''RelMealLaunch

tableContext :: TableContext
tableContext = TableContext
    relMealLaunch
    officeId
    officeId'
    "rel_meal_launch"
    "office_id"
    fields
