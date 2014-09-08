
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelPeeSameSex where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_pee_same_sex"
deriveJSON defaultOptions ''RelPeeSameSex
mkFields ''RelPeeSameSex

tableContext :: TableContext
tableContext = TableContext
    relPeeSameSex
    officeId
    officeId'
    "rel_pee_same_sex"
    "office_id"
    fields
