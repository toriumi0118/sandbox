
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAlcohol where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_alcohol"
deriveJSON defaultOptions ''RelAlcohol
mkFields ''RelAlcohol

tableContext :: TableContext RelAlcohol
tableContext = TableContext
    relAlcohol
    officeId
    officeId'
    "rel_alcohol"
    "office_id"
    fields
