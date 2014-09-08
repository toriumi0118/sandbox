
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelWheelchair where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_wheelchair"
deriveJSON defaultOptions ''RelWheelchair
mkFields ''RelWheelchair

tableContext :: TableContext
tableContext = TableContext
    relWheelchair
    officeId
    officeId'
    "rel_wheelchair"
    "office_id"
    fields
