{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSpecialField where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_special_field"
deriveJSON defaultOptions ''RelSpecialField
mkFields ''RelSpecialField

tableContext :: TableContext RelSpecialField
tableContext = TableContext
    relSpecialField
    officeId
    officeId'
    "rel_special_field"
    "office_id"
    fields
    Nothing
