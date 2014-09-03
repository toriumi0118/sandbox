{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)
import TH

defineTable "office_price"
deriveJSON defaultOptions ''OfficePrice
fields ''OfficePrice
