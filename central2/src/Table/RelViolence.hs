{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelViolence where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_violence"
deriveJSON defaultOptions ''RelViolence
mkFields ''RelViolence

tableContext :: TableContext RelViolence
tableContext = TableContext
    relViolence
    officeId
    officeId'
    "rel_violence"
    "office_id"
    fields
    Nothing
