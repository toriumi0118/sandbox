
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMaleDay where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_male_day"
deriveJSON defaultOptions ''RelMaleDay
mkFields ''RelMaleDay

tableContext :: TableContext
tableContext = TableContext
    relMaleDay
    officeId
    officeId'
    "rel_male_day"
    "office_id"
    fields
