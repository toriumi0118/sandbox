{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeSpPriceHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Json ()
import DataSource (defineTable)

defineTable "office_sp_price_history"

deriveJSON defaultOptions ''OfficeSpPriceHistory
