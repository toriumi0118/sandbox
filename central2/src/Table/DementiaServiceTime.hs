
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.DementiaServiceTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "dementia_service_time"
deriveJSON defaultOptions ''DementiaServiceTime
mkFields ''DementiaServiceTime

tableContext :: TableContext DementiaServiceTime
tableContext = TableContext
    dementiaServiceTime
    officeId
    officeId'
    "dementia_service_time"
    "office_id"
    fields
