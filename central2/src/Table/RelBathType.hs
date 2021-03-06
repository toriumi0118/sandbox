{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathType where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_bath_type"
deriveJSON defaultOptions ''RelBathType
mkFields ''RelBathType

tableContext :: TableContext RelBathType
tableContext = TableContext
    relBathType
    officeId
    officeId'
    "rel_bath_type"
    "office_id"
    fields
    NoParam
