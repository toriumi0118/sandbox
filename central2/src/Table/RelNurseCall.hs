
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelNurseCall where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_nurse_call"
deriveJSON defaultOptions ''RelNurseCall
mkFields ''RelNurseCall

tableContext :: TableContext
tableContext = TableContext
    relNurseCall
    officeId
    officeId'
    "rel_nurse_call"
    "office_id"
    fields
