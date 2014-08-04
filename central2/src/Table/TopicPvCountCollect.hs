{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.TopicPvCountCollect where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.HDBC.Query.TH (defineTableFromDB)
import Database.HDBC.Schema.PostgreSQL (driverPostgreSQL)
import Database.Record.TH (derivingShow)

import DataSource (connect)

$(defineTableFromDB
    connect
    driverPostgreSQL
    "public"
    "topic_pv_count_collect"
    [derivingShow])

$(deriveJSON defaultOptions ''TopicPvCountCollect)
