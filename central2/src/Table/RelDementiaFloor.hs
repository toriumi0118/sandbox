{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaFloor where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_floor"
deriveJSON defaultOptions ''RelDementiaFloor
mkFields ''RelDementiaFloor

tableContext :: TableContext RelDementiaFloor
tableContext = TableContext
    relDementiaFloor
    officeId
    officeId'
    "rel_dementia_floor"
    "office_id"
    fields
    Nothing
