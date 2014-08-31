{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceBuildingPresentationHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)

defineTable "service_building_presentation_history"

deriveJSON defaultOptions ''ServiceBuildingPresentationHistory
