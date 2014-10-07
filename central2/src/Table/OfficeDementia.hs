{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeDementia where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office_dementia"
deriveJSON defaultOptions ''OfficeDementia
mkFields ''OfficeDementia

tableContext :: TableContext OfficeDementia
tableContext = TableContext
    officeDementia
    officeId
    officeId'
    "office_dementia"
    "office_id"
    fields
    NoParam
