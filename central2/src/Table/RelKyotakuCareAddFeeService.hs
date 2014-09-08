
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuCareAddFeeService where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_kyotaku_care_add_fee_service"
deriveJSON defaultOptions ''RelKyotakuCareAddFeeService
mkFields ''RelKyotakuCareAddFeeService

tableContext :: TableContext
tableContext = TableContext
    relKyotakuCareAddFeeService
    officeId
    officeId'
    "rel_kyotaku_care_add_fee_service"
    "office_id"
    fields
