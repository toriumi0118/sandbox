
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.DementiaBusinessTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "dementia_business_time"
deriveJSON defaultOptions ''DementiaBusinessTime
mkFields ''DementiaBusinessTime

tableContext :: TableContext
tableContext = TableContext
    dementiaBusinessTime
    officeId
    officeId'
    "dementia_business_time"
    "office_id"
    fields
