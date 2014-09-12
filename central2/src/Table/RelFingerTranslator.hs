{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFingerTranslator where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_finger_translator"
deriveJSON defaultOptions ''RelFingerTranslator
mkFields ''RelFingerTranslator

tableContext :: TableContext RelFingerTranslator
tableContext = TableContext
    relFingerTranslator
    officeId
    officeId'
    "rel_finger_translator"
    "office_id"
    fields
    NoParam
