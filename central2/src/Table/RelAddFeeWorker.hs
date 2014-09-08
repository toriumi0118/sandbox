
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFeeWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_add_fee_worker"
deriveJSON defaultOptions ''RelAddFeeWorker
mkFields ''RelAddFeeWorker

tableContext :: TableContext
tableContext = TableContext
    relAddFeeWorker
    officeId
    officeId'
    "rel_add_fee_worker"
    "office_id"
    fields
