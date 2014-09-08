
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelNewspaper where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_newspaper"
deriveJSON defaultOptions ''RelNewspaper
mkFields ''RelNewspaper

tableContext :: TableContext
tableContext = TableContext
    relNewspaper
    officeId
    officeId'
    "rel_newspaper"
    "office_id"
    fields
