
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelScale where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_scale"
deriveJSON defaultOptions ''RelScale
mkFields ''RelScale

tableContext :: TableContext
tableContext = TableContext
    relScale
    officeId
    officeId'
    "rel_scale"
    "office_id"
    fields
