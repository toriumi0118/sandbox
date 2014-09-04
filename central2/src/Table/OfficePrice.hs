{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH

defineTable "office_price"
deriveJSON defaultOptions ''OfficePrice
fields ''OfficePrice

tableContext :: TableContext OfficePrice
tableContext = TableContext
    officePrice
    officeId
    officeId'
    "office_price"
    "officeId"
    officePriceFields
