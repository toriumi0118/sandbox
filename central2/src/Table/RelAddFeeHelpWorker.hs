{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFeeHelpWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_add_fee_help_worker"
deriveJSON defaultOptions ''RelAddFeeHelpWorker
mkFields ''RelAddFeeHelpWorker

tableContext :: TableContext RelAddFeeHelpWorker
tableContext = TableContext
    relAddFeeHelpWorker
    officeId
    officeId'
    "rel_add_fee_help_worker"
    "office_id"
    fields
    NoParam
