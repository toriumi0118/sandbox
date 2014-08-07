{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.PvCountCollect where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

defineTable "pv_count_collect"

deriveJSON defaultOptions ''PvCountCollect
