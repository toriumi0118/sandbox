
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeLicence where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_licence"
deriveJSON defaultOptions ''OfficeLicence
mkFields ''OfficeLicence

tableContext :: TableContext
tableContext = TableContext
    officeLicence
    officeId
    officeId'
    "office_licence"
    "office_id"
    fields
