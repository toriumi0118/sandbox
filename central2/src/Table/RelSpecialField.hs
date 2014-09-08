
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSpecialField where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_special_field"
deriveJSON defaultOptions ''RelSpecialField
mkFields ''RelSpecialField

tableContext :: TableContext
tableContext = TableContext
    relSpecialField
    officeId
    officeId'
    "rel_special_field"
    "office_id"
    fields
