{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Json ()
import DataSource (defineTable)

defineTable "office_history"

deriveJSON defaultOptions ''OfficeHistory
