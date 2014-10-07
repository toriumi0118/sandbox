{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelUserTablet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_user_tablet"
deriveJSON defaultOptions ''RelUserTablet
mkFields ''RelUserTablet

tableContext :: TableContext RelUserTablet
tableContext = TableContext
    relUserTablet
    officeId
    officeId'
    "rel_user_tablet"
    "office_id"
    fields
    NoParam
