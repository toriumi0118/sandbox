{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Office where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query

import Controller.Types.Class ()
import DataSource (defineTable)
import TH

defineTable "office"
deriveJSON defaultOptions ''Office
fields ''Office
