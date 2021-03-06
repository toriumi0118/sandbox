{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelWithBuilding where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_with_building"
deriveJSON defaultOptions ''RelWithBuilding
mkFields ''RelWithBuilding

tableContext :: TableContext RelWithBuilding
tableContext = TableContext
    relWithBuilding
    officeId
    officeId'
    "rel_with_building"
    "office_id"
    fields
    NoParam
