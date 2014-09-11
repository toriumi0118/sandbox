{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelWheelchair where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_wheelchair"
deriveJSON defaultOptions ''RelWheelchair
mkFields ''RelWheelchair

tableContext :: TableContext RelWheelchair
tableContext = TableContext
    relWheelchair
    officeId
    officeId'
    "rel_wheelchair"
    "office_id"
    fields
    Nothing
