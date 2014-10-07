{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelatedOffice where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "related_office"
deriveJSON defaultOptions ''RelatedOffice
mkFields ''RelatedOffice

tableContext :: TableContext RelatedOffice
tableContext = TableContext
    relatedOffice
    id
    id'
    "related_office"
    "id"
    fields
    NoParam
