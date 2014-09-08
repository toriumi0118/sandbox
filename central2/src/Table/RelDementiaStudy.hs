
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaStudy where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_study"
deriveJSON defaultOptions ''RelDementiaStudy
mkFields ''RelDementiaStudy

tableContext :: TableContext
tableContext = TableContext
    relDementiaStudy
    officeId
    officeId'
    "rel_dementia_study"
    "office_id"
    fields
