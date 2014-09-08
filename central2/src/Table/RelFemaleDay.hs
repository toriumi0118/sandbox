
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFemaleDay where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_female_day"
deriveJSON defaultOptions ''RelFemaleDay
mkFields ''RelFemaleDay

tableContext :: TableContext
tableContext = TableContext
    relFemaleDay
    officeId
    officeId'
    "rel_female_day"
    "office_id"
    fields
