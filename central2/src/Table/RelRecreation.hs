
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelRecreation where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_recreation"
deriveJSON defaultOptions ''RelRecreation
mkFields ''RelRecreation

tableContext :: TableContext RelRecreation
tableContext = TableContext
    relRecreation
    officeId
    officeId'
    "rel_recreation"
    "office_id"
    fields
