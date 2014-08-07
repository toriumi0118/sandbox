{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.TopicPvCountCollect where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

$(defineTable "topic_pv_count_collect")

$(deriveJSON defaultOptions ''TopicPvCountCollect)
