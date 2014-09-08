
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHotline where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_hotline"
deriveJSON defaultOptions ''RelHotline
mkFields ''RelHotline

tableContext :: TableContext
tableContext = TableContext
    relHotline
    officeId
    officeId'
    "rel_hotline"
    "office_id"
    fields
