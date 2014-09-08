
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSpeechTherapist where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_speech_therapist"
deriveJSON defaultOptions ''RelSpeechTherapist
mkFields ''RelSpeechTherapist

tableContext :: TableContext
tableContext = TableContext
    relSpeechTherapist
    officeId
    officeId'
    "rel_speech_therapist"
    "office_id"
    fields
