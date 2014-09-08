
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBrainTraining where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_brain_training"
deriveJSON defaultOptions ''RelBrainTraining
mkFields ''RelBrainTraining

tableContext :: TableContext
tableContext = TableContext
    relBrainTraining
    officeId
    officeId'
    "rel_brain_training"
    "office_id"
    fields
