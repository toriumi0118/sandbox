
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDoseManage where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dose_manage"
deriveJSON defaultOptions ''RelDoseManage
mkFields ''RelDoseManage

tableContext :: TableContext
tableContext = TableContext
    relDoseManage
    officeId
    officeId'
    "rel_dose_manage"
    "office_id"
    fields
