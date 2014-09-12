{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealKampo where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_kampo"
deriveJSON defaultOptions ''RelMealKampo
mkFields ''RelMealKampo

tableContext :: TableContext RelMealKampo
tableContext = TableContext
    relMealKampo
    officeId
    officeId'
    "rel_meal_kampo"
    "office_id"
    fields
    NoParam
