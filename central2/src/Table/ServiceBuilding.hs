
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuilding where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

defineTable "service_building"

deriveJSON defaultOptions ''ServiceBuilding
