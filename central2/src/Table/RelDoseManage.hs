{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDoseManage where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dose_manage"
deriveJSON defaultOptions ''RelDoseManage
mkFields ''RelDoseManage

tableContext :: TableContext RelDoseManage
tableContext = TableContext
    relDoseManage
    officeId
    officeId'
    "rel_dose_manage"
    "office_id"
    fields
    NoParam
