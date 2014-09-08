
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaAddFeeWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_add_fee_worker"
deriveJSON defaultOptions ''RelDementiaAddFeeWorker
mkFields ''RelDementiaAddFeeWorker

tableContext :: TableContext
tableContext = TableContext
    relDementiaAddFeeWorker
    officeId
    officeId'
    "rel_dementia_add_fee_worker"
    "office_id"
    fields
