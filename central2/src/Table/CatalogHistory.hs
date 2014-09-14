{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.CatalogHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import DataSource (defineTable)

defineTable "catalog_history"

deriveJSON defaultOptions ''CatalogHistory
