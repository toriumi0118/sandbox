{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelHotline where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_hotline"
deriveJSON defaultOptions ''RelHotline
mkFields ''RelHotline

tableContext :: TableContext RelHotline
tableContext = TableContext
    relHotline
    officeId
    officeId'
    "rel_hotline"
    "office_id"
    fields
    NoParam
