
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeAppealPoint where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_appeal_point"
deriveJSON defaultOptions ''OfficeAppealPoint
mkFields ''OfficeAppealPoint

tableContext :: TableContext
tableContext = TableContext
    officeAppealPoint
    officeId
    officeId'
    "office_appeal_point"
    "office_id"
    fields
