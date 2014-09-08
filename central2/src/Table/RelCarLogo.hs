
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelCarLogo where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_car_logo"
deriveJSON defaultOptions ''RelCarLogo
mkFields ''RelCarLogo

tableContext :: TableContext
tableContext = TableContext
    relCarLogo
    officeId
    officeId'
    "rel_car_logo"
    "office_id"
    fields
