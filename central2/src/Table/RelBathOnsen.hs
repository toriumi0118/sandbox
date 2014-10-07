{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathOnsen where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_bath_onsen"
deriveJSON defaultOptions ''RelBathOnsen
mkFields ''RelBathOnsen

tableContext :: TableContext RelBathOnsen
tableContext = TableContext
    relBathOnsen
    officeId
    officeId'
    "rel_bath_onsen"
    "office_id"
    fields
    NoParam
