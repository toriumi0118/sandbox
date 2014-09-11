
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelCarLogo where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_car_logo"
deriveJSON defaultOptions ''RelCarLogo
mkFields ''RelCarLogo

tableContext :: TableContext RelCarLogo
tableContext = TableContext
    relCarLogo
    officeId
    officeId'
    "rel_car_logo"
    "office_id"
    fields
    Nothing
