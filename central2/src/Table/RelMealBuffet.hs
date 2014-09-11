
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMealBuffet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_meal_buffet"
deriveJSON defaultOptions ''RelMealBuffet
mkFields ''RelMealBuffet

tableContext :: TableContext RelMealBuffet
tableContext = TableContext
    relMealBuffet
    officeId
    officeId'
    "rel_meal_buffet"
    "office_id"
    fields
    Nothing
