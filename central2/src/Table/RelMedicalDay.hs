
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelMedicalDay where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_medical_day"
deriveJSON defaultOptions ''RelMedicalDay
mkFields ''RelMedicalDay

tableContext :: TableContext RelMedicalDay
tableContext = TableContext
    relMedicalDay
    officeId
    officeId'
    "rel_medical_day"
    "office_id"
    fields
    Nothing
