
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.DementiaServiceTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "dementia_service_time"
deriveJSON defaultOptions ''DementiaServiceTime
mkFields ''DementiaServiceTime

tableContext :: TableContext
tableContext = TableContext
    dementiaServiceTime
    officeId
    officeId'
    "dementia_service_time"
    "office_id"
    fields
