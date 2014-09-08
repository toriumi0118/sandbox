
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathWay where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_way"
deriveJSON defaultOptions ''RelBathWay
mkFields ''RelBathWay

tableContext :: TableContext
tableContext = TableContext
    relBathWay
    officeId
    officeId'
    "rel_bath_way"
    "office_id"
    fields
