{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFeeWorker where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_add_fee_worker"
deriveJSON defaultOptions ''RelAddFeeWorker
mkFields ''RelAddFeeWorker

tableContext :: TableContext RelAddFeeWorker
tableContext = TableContext
    relAddFeeWorker
    officeId
    officeId'
    "rel_add_fee_worker"
    "office_id"
    fields
    NoParam
