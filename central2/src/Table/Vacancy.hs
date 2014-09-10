
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Vacancy where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "vacancy"
deriveJSON defaultOptions ''Vacancy
mkFields ''Vacancy

tableContext :: TableContext Vacancy
tableContext = TableContext
    vacancy
    officeId
    officeId'
    "vacancy"
    "office_id"
    fields
