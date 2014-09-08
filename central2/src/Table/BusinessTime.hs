
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.BusinessTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "business_time"
deriveJSON defaultOptions ''BusinessTime
mkFields ''BusinessTime

tableContext :: TableContext
tableContext = TableContext
    businessTime
    officeId
    officeId'
    "business_time"
    "office_id"
    fields
