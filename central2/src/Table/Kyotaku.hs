{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Kyotaku where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "kyotaku"
deriveJSON defaultOptions ''Kyotaku
mkFields ''Kyotaku

tableContext :: TableContext Kyotaku
tableContext = TableContext
    kyotaku
    officeId
    officeId'
    "kyotaku"
    "office_id"
    fields
    Nothing
