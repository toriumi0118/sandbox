{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Version where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Json ()
import DataSource (defineTable)

defineTable "version"

deriveJSON defaultOptions ''Version
