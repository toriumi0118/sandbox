{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSelfOut where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_self_out"
deriveJSON defaultOptions ''RelSelfOut
mkFields ''RelSelfOut

tableContext :: TableContext RelSelfOut
tableContext = TableContext
    relSelfOut
    officeId
    officeId'
    "rel_self_out"
    "office_id"
    fields
    Nothing
