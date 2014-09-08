
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuCareAddFeeStaff where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_kyotaku_care_add_fee_staff"
deriveJSON defaultOptions ''RelKyotakuCareAddFeeStaff
mkFields ''RelKyotakuCareAddFeeStaff

tableContext :: TableContext
tableContext = TableContext
    relKyotakuCareAddFeeStaff
    officeId
    officeId'
    "rel_kyotaku_care_add_fee_staff"
    "office_id"
    fields
