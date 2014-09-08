
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathMicroBubble where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_bath_micro_bubble"
deriveJSON defaultOptions ''RelBathMicroBubble
mkFields ''RelBathMicroBubble

tableContext :: TableContext
tableContext = TableContext
    relBathMicroBubble
    officeId
    officeId'
    "rel_bath_micro_bubble"
    "office_id"
    fields
