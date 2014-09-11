{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHiyari where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_hiyari"
deriveJSON defaultOptions ''RelHiyari
mkFields ''RelHiyari

tableContext :: TableContext RelHiyari
tableContext = TableContext
    relHiyari
    officeId
    officeId'
    "rel_hiyari"
    "office_id"
    fields
    Nothing
