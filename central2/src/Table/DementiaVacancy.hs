
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.DementiaVacancy where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "dementia_vacancy"
deriveJSON defaultOptions ''DementiaVacancy
mkFields ''DementiaVacancy

tableContext :: TableContext
tableContext = TableContext
    dementiaVacancy
    officeId
    officeId'
    "dementia_vacancy"
    "office_id"
    fields
