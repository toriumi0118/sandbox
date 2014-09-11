
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelVolunteer where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_volunteer"
deriveJSON defaultOptions ''RelVolunteer
mkFields ''RelVolunteer

tableContext :: TableContext RelVolunteer
tableContext = TableContext
    relVolunteer
    officeId
    officeId'
    "rel_volunteer"
    "office_id"
    fields
    Nothing
