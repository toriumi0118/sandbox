
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office_price"
deriveJSON defaultOptions ''OfficePrice
mkFields ''OfficePrice

tableContext :: TableContext OfficePrice
tableContext = TableContext
    officePrice
    officeId
    officeId'
    "office_price"
    "office_id"
    fields
    Nothing
