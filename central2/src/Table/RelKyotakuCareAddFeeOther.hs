{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuCareAddFeeOther where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_kyotaku_care_add_fee_other"
deriveJSON defaultOptions ''RelKyotakuCareAddFeeOther
mkFields ''RelKyotakuCareAddFeeOther

tableContext :: TableContext RelKyotakuCareAddFeeOther
tableContext = TableContext
    relKyotakuCareAddFeeOther
    officeId
    officeId'
    "rel_kyotaku_care_add_fee_other"
    "office_id"
    fields
    NoParam
