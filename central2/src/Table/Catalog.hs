{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Catalog where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "catalog"
deriveJSON defaultOptions ''Catalog
mkFields ''Catalog

tableContext :: TableContext Catalog
tableContext = TableContext
    catalog
    (fromIntegral . id)
    (fromIntegral |$| id')
    "catalog"
    "id"
    fields
    NoParam
