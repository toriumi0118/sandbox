{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Device where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

defineTable "device"

deriveJSON defaultOptions ''Device
