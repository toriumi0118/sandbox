
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.KyotakuLicense where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "kyotaku_license"
deriveJSON defaultOptions ''KyotakuLicense
mkFields ''KyotakuLicense

tableContext :: TableContext
tableContext = TableContext
    kyotakuLicense
    officeId
    officeId'
    "kyotaku_license"
    "office_id"
    fields
