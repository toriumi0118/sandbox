{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelLocalCommunication where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_local_communication"
deriveJSON defaultOptions ''RelLocalCommunication
mkFields ''RelLocalCommunication

tableContext :: TableContext RelLocalCommunication
tableContext = TableContext
    relLocalCommunication
    officeId
    officeId'
    "rel_local_communication"
    "office_id"
    fields
    NoParam
