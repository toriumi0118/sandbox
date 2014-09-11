{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.DementiaVacancy where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "dementia_vacancy"
deriveJSON defaultOptions ''DementiaVacancy
mkFields ''DementiaVacancy

tableContext :: TableContext DementiaVacancy
tableContext = TableContext
    dementiaVacancy
    officeId
    officeId'
    "dementia_vacancy"
    "office_id"
    fields
    Nothing
