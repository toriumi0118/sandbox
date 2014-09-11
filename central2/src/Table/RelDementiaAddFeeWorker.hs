
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaAddFeeWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_add_fee_worker"
deriveJSON defaultOptions ''RelDementiaAddFeeWorker
mkFields ''RelDementiaAddFeeWorker

tableContext :: TableContext RelDementiaAddFeeWorker
tableContext = TableContext
    relDementiaAddFeeWorker
    officeId
    officeId'
    "rel_dementia_add_fee_worker"
    "office_id"
    fields
    Nothing
