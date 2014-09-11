
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelNurseCall where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_nurse_call"
deriveJSON defaultOptions ''RelNurseCall
mkFields ''RelNurseCall

tableContext :: TableContext RelNurseCall
tableContext = TableContext
    relNurseCall
    officeId
    officeId'
    "rel_nurse_call"
    "office_id"
    fields
    Nothing
