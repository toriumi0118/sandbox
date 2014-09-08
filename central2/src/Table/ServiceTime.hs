
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "service_time"
deriveJSON defaultOptions ''ServiceTime
mkFields ''ServiceTime

tableContext :: TableContext
tableContext = TableContext
    serviceTime
    officeId
    officeId'
    "service_time"
    "office_id"
    fields
