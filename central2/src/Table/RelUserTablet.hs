
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelUserTablet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_user_tablet"
deriveJSON defaultOptions ''RelUserTablet
mkFields ''RelUserTablet

tableContext :: TableContext
tableContext = TableContext
    relUserTablet
    officeId
    officeId'
    "rel_user_tablet"
    "office_id"
    fields
