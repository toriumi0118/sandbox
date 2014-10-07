{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBrainTraining where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_brain_training"
deriveJSON defaultOptions ''RelBrainTraining
mkFields ''RelBrainTraining

tableContext :: TableContext RelBrainTraining
tableContext = TableContext
    relBrainTraining
    officeId
    officeId'
    "rel_brain_training"
    "office_id"
    fields
    NoParam
