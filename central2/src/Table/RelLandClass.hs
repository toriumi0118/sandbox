
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelLandClass where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_land_class"
deriveJSON defaultOptions ''RelLandClass
mkFields ''RelLandClass

tableContext :: TableContext RelLandClass
tableContext = TableContext
    relLandClass
    officeId
    officeId'
    "rel_land_class"
    "office_id"
    fields
    Nothing
