{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSpeechTherapist where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_speech_therapist"
deriveJSON defaultOptions ''RelSpeechTherapist
mkFields ''RelSpeechTherapist

tableContext :: TableContext RelSpeechTherapist
tableContext = TableContext
    relSpeechTherapist
    officeId
    officeId'
    "rel_speech_therapist"
    "office_id"
    fields
    NoParam
