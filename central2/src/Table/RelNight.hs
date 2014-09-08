
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelNight where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_night"
deriveJSON defaultOptions ''RelNight
mkFields ''RelNight

tableContext :: TableContext
tableContext = TableContext
    relNight
    officeId
    officeId'
    "rel_night"
    "office_id"
    fields
