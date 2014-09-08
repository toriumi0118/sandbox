
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuCareAddFeeOther where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_kyotaku_care_add_fee_other"
deriveJSON defaultOptions ''RelKyotakuCareAddFeeOther
mkFields ''RelKyotakuCareAddFeeOther

tableContext :: TableContext
tableContext = TableContext
    relKyotakuCareAddFeeOther
    officeId
    officeId'
    "rel_kyotaku_care_add_fee_other"
    "office_id"
    fields
