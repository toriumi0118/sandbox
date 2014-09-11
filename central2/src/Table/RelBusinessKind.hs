{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBusinessKind where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_business_kind"
deriveJSON defaultOptions ''RelBusinessKind
mkFields ''RelBusinessKind

tableContext :: TableContext RelBusinessKind
tableContext = TableContext
    relBusinessKind
    officeId
    officeId'
    "rel_business_kind"
    "office_id"
    fields
    Nothing
