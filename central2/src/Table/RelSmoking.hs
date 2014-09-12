{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSmoking where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_smoking"
deriveJSON defaultOptions ''RelSmoking
mkFields ''RelSmoking

tableContext :: TableContext RelSmoking
tableContext = TableContext
    relSmoking
    officeId
    officeId'
    "rel_smoking"
    "office_id"
    fields
    NoParam
