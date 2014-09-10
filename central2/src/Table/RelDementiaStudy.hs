
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaStudy where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_study"
deriveJSON defaultOptions ''RelDementiaStudy
mkFields ''RelDementiaStudy

tableContext :: TableContext RelDementiaStudy
tableContext = TableContext
    relDementiaStudy
    officeId
    officeId'
    "rel_dementia_study"
    "office_id"
    fields
