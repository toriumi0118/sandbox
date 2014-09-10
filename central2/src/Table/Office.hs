
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Office where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office"
deriveJSON defaultOptions ''Office
mkFields ''Office

tableContext :: TableContext Office
tableContext = TableContext
    office
    officeId
    officeId'
    "office"
    "office_id"
    fields
