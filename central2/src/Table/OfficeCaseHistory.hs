{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeCaseHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class (History)
import DataSource (defineTable)

defineTable "office_case_history"

deriveJSON defaultOptions ''OfficeCaseHistory

instance History OfficeCaseHistory
