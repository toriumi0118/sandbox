{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.KyotakuLicense where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "kyotaku_license"
deriveJSON defaultOptions ''KyotakuLicense
mkFields ''KyotakuLicense

tableContext :: TableContext KyotakuLicense
tableContext = TableContext
    kyotakuLicense
    officeId
    officeId'
    "kyotaku_license"
    "office_id"
    fields
    NoParam
