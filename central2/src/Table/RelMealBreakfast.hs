{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealBreakfast where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_breakfast"
deriveJSON defaultOptions ''RelMealBreakfast
mkFields ''RelMealBreakfast

tableContext :: TableContext RelMealBreakfast
tableContext = TableContext
    relMealBreakfast
    officeId
    officeId'
    "rel_meal_breakfast"
    "office_id"
    fields
    NoParam
