
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelArchitecture where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_architecture"
deriveJSON defaultOptions ''RelArchitecture
mkFields ''RelArchitecture

tableContext :: TableContext RelArchitecture
tableContext = TableContext
    relArchitecture
    officeId
    officeId'
    "rel_architecture"
    "office_id"
    fields
    Nothing
