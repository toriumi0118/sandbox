
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Vacancy where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "vacancy"
deriveJSON defaultOptions ''Vacancy
mkFields ''Vacancy

tableContext :: TableContext
tableContext = TableContext
    vacancy
    officeId
    officeId'
    "vacancy"
    "office_id"
    fields
