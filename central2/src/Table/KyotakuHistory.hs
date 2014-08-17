{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.KyotakuHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Json ()
import DataSource (defineTable)

defineTable "kyotaku_history"

deriveJSON defaultOptions ''KyotakuHistory
