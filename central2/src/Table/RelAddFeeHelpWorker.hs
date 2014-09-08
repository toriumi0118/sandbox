
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFeeHelpWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_add_fee_help_worker"
deriveJSON defaultOptions ''RelAddFeeHelpWorker
mkFields ''RelAddFeeHelpWorker

tableContext :: TableContext
tableContext = TableContext
    relAddFeeHelpWorker
    officeId
    officeId'
    "rel_add_fee_help_worker"
    "office_id"
    fields
