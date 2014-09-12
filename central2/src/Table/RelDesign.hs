{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDesign where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_design"
deriveJSON defaultOptions ''RelDesign
mkFields ''RelDesign

tableContext :: TableContext RelDesign
tableContext = TableContext
    relDesign
    officeId
    officeId'
    "rel_design"
    "office_id"
    fields
    NoParam
