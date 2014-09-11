{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Topic where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "topic"
deriveJSON defaultOptions ''Topic
mkFields ''Topic

tableContext :: TableContext Topic
tableContext = TableContext
    topic
    id
    id'
    "topic"
    "id"
    fields
    Nothing
