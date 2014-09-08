
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFingerTranslator where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_finger_translator"
deriveJSON defaultOptions ''RelFingerTranslator
mkFields ''RelFingerTranslator

tableContext :: TableContext
tableContext = TableContext
    relFingerTranslator
    officeId
    officeId'
    "rel_finger_translator"
    "office_id"
    fields
