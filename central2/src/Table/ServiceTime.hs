
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.ServiceTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "service_time"
deriveJSON defaultOptions ''ServiceTime
mkFields ''ServiceTime

tableContext :: TableContext ServiceTime
tableContext = TableContext
    serviceTime
    officeId
    officeId'
    "service_time"
    "office_id"
    fields
    Nothing
