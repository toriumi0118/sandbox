{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMidnightMeal where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_midnight_meal"
deriveJSON defaultOptions ''RelMidnightMeal
mkFields ''RelMidnightMeal

tableContext :: TableContext RelMidnightMeal
tableContext = TableContext
    relMidnightMeal
    officeId
    officeId'
    "rel_midnight_meal"
    "office_id"
    fields
    NoParam
