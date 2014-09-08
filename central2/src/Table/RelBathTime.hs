
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_time"
deriveJSON defaultOptions ''RelBathTime
mkFields ''RelBathTime

tableContext :: TableContext
tableContext = TableContext
    relBathTime
    officeId
    officeId'
    "rel_bath_time"
    "office_id"
    fields
