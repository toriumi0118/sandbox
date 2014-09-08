
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.KyotakuBusinessTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "kyotaku_business_time"
deriveJSON defaultOptions ''KyotakuBusinessTime
mkFields ''KyotakuBusinessTime

tableContext :: TableContext
tableContext = TableContext
    kyotakuBusinessTime
    officeId
    officeId'
    "kyotaku_business_time"
    "office_id"
    fields
