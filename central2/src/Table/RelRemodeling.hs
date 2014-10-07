{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelRemodeling where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_remodeling"
deriveJSON defaultOptions ''RelRemodeling
mkFields ''RelRemodeling

tableContext :: TableContext RelRemodeling
tableContext = TableContext
    relRemodeling
    officeId
    officeId'
    "rel_remodeling"
    "office_id"
    fields
    NoParam
