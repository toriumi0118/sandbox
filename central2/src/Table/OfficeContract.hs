
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeContract where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_contract"
deriveJSON defaultOptions ''OfficeContract
mkFields ''OfficeContract

tableContext :: TableContext
tableContext = TableContext
    officeContract
    officeId
    officeId'
    "office_contract"
    "office_id"
    fields
