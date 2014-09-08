
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Office where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office"
deriveJSON defaultOptions ''Office
mkFields ''Office

tableContext :: TableContext Office
tableContext = TableContext
    office
    officeId
    officeId'
    "office"
    "officeId"
    fields
