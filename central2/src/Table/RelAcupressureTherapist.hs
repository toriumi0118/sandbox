
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAcupressureTherapist where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_acupressure_therapist"
deriveJSON defaultOptions ''RelAcupressureTherapist
mkFields ''RelAcupressureTherapist

tableContext :: TableContext
tableContext = TableContext
    relAcupressureTherapist
    officeId
    officeId'
    "rel_acupressure_therapist"
    "office_id"
    fields
