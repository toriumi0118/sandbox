{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH

defineTable "office_price"
deriveJSON defaultOptions ''OfficePrice
mkFields ''OfficePrice

tableContext :: TableContext
tableContext = TableContext
    officePrice
    officeId
    officeId'
    "office_price"
    "office_id"
    fields
