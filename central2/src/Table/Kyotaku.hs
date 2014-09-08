
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Kyotaku where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "kyotaku"
deriveJSON defaultOptions ''Kyotaku
mkFields ''Kyotaku

tableContext :: TableContext
tableContext = TableContext
    kyotaku
    officeId
    officeId'
    "kyotaku"
    "office_id"
    fields
