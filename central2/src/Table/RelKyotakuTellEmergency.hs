
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuTellEmergency where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_kyotaku_tell_emergency"
deriveJSON defaultOptions ''RelKyotakuTellEmergency
mkFields ''RelKyotakuTellEmergency

tableContext :: TableContext
tableContext = TableContext
    relKyotakuTellEmergency
    officeId
    officeId'
    "rel_kyotaku_tell_emergency"
    "office_id"
    fields
