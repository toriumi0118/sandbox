
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelLandClass where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_land_class"
deriveJSON defaultOptions ''RelLandClass
mkFields ''RelLandClass

tableContext :: TableContext
tableContext = TableContext
    relLandClass
    officeId
    officeId'
    "rel_land_class"
    "office_id"
    fields
