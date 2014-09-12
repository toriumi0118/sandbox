{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealOut where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_out"
deriveJSON defaultOptions ''RelMealOut
mkFields ''RelMealOut

tableContext :: TableContext RelMealOut
tableContext = TableContext
    relMealOut
    officeId
    officeId'
    "rel_meal_out"
    "office_id"
    fields
    NoParam
