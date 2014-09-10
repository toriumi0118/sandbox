
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuCareAddFeeStaff where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_kyotaku_care_add_fee_staff"
deriveJSON defaultOptions ''RelKyotakuCareAddFeeStaff
mkFields ''RelKyotakuCareAddFeeStaff

tableContext :: TableContext RelKyotakuCareAddFeeStaff
tableContext = TableContext
    relKyotakuCareAddFeeStaff
    officeId
    officeId'
    "rel_kyotaku_care_add_fee_staff"
    "office_id"
    fields
