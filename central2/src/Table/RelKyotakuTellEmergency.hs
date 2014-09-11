
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuTellEmergency where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_kyotaku_tell_emergency"
deriveJSON defaultOptions ''RelKyotakuTellEmergency
mkFields ''RelKyotakuTellEmergency

tableContext :: TableContext RelKyotakuTellEmergency
tableContext = TableContext
    relKyotakuTellEmergency
    officeId
    officeId'
    "rel_kyotaku_tell_emergency"
    "office_id"
    fields
    Nothing
