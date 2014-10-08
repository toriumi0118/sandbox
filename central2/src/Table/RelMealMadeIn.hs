{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealMadeIn where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_made_in"
deriveJSON defaultOptions ''RelMealMadeIn
mkFields ''RelMealMadeIn

tableContext :: TableContext RelMealMadeIn
tableContext = TableContext
    relMealMadeIn
    officeId
    officeId'
    "rel_meal_made_in"
    "office_id"
    fields
    NoParam
