{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Json ()
import DataSource (defineTable)

defineTable "news_history"

deriveJSON defaultOptions ''NewsHistory
