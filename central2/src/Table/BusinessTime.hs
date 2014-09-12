{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.BusinessTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "business_time"
deriveJSON defaultOptions ''BusinessTime
mkFields ''BusinessTime

tableContext :: TableContext BusinessTime
tableContext = TableContext
    businessTime
    officeId
    officeId'
    "business_time"
    "office_id"
    fields
    NoParam
