{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMassage where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_massage"
deriveJSON defaultOptions ''RelMassage
mkFields ''RelMassage

tableContext :: TableContext RelMassage
tableContext = TableContext
    relMassage
    officeId
    officeId'
    "rel_massage"
    "office_id"
    fields
    Nothing
