{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Office where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query

import Controller.Types.Class ()
import DataSource (defineTable)

defineTable "office"

deriveJSON defaultOptions ''Office
