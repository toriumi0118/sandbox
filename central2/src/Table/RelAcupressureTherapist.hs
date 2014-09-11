
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAcupressureTherapist where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_acupressure_therapist"
deriveJSON defaultOptions ''RelAcupressureTherapist
mkFields ''RelAcupressureTherapist

tableContext :: TableContext RelAcupressureTherapist
tableContext = TableContext
    relAcupressureTherapist
    officeId
    officeId'
    "rel_acupressure_therapist"
    "office_id"
    fields
    Nothing
