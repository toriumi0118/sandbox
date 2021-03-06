{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathSameSex where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_bath_same_sex"
deriveJSON defaultOptions ''RelBathSameSex
mkFields ''RelBathSameSex

tableContext :: TableContext RelBathSameSex
tableContext = TableContext
    relBathSameSex
    officeId
    officeId'
    "rel_bath_same_sex"
    "office_id"
    fields
    NoParam
