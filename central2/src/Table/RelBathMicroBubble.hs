
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathMicroBubble where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_bath_micro_bubble"
deriveJSON defaultOptions ''RelBathMicroBubble
mkFields ''RelBathMicroBubble

tableContext :: TableContext RelBathMicroBubble
tableContext = TableContext
    relBathMicroBubble
    officeId
    officeId'
    "rel_bath_micro_bubble"
    "office_id"
    fields
    Nothing
