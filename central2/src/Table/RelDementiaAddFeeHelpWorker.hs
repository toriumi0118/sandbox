
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaAddFeeHelpWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_add_fee_help_worker"
deriveJSON defaultOptions ''RelDementiaAddFeeHelpWorker
mkFields ''RelDementiaAddFeeHelpWorker

tableContext :: TableContext
tableContext = TableContext
    relDementiaAddFeeHelpWorker
    officeId
    officeId'
    "rel_dementia_add_fee_help_worker"
    "office_id"
    fields
