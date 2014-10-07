{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelScale where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_scale"
deriveJSON defaultOptions ''RelScale
mkFields ''RelScale

tableContext :: TableContext RelScale
tableContext = TableContext
    relScale
    officeId
    officeId'
    "rel_scale"
    "office_id"
    fields
    NoParam
