
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeDementia where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_dementia"
deriveJSON defaultOptions ''OfficeDementia
mkFields ''OfficeDementia

tableContext :: TableContext
tableContext = TableContext
    officeDementia
    officeId
    officeId'
    "office_dementia"
    "office_id"
    fields
