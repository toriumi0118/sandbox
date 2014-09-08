
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelVolunteer where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_volunteer"
deriveJSON defaultOptions ''RelVolunteer
mkFields ''RelVolunteer

tableContext :: TableContext
tableContext = TableContext
    relVolunteer
    officeId
    officeId'
    "rel_volunteer"
    "office_id"
    fields
