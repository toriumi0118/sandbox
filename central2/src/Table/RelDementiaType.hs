
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaType where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_type"
deriveJSON defaultOptions ''RelDementiaType
mkFields ''RelDementiaType

tableContext :: TableContext RelDementiaType
tableContext = TableContext
    relDementiaType
    officeId
    officeId'
    "rel_dementia_type"
    "office_id"
    fields
    Nothing
