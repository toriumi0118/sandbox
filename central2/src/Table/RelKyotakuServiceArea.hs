{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelKyotakuServiceArea where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_kyotaku_service_area"
deriveJSON defaultOptions ''RelKyotakuServiceArea
mkFields ''RelKyotakuServiceArea

tableContext :: TableContext RelKyotakuServiceArea
tableContext = TableContext
    relKyotakuServiceArea
    officeId
    officeId'
    "rel_kyotaku_service_area"
    "office_id"
    fields
    NoParam
