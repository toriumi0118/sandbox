
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelOralCare where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_oral_care"
deriveJSON defaultOptions ''RelOralCare
mkFields ''RelOralCare

tableContext :: TableContext
tableContext = TableContext
    relOralCare
    officeId
    officeId'
    "rel_oral_care"
    "office_id"
    fields
