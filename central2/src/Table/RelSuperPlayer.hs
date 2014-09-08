
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSuperPlayer where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_super_player"
deriveJSON defaultOptions ''RelSuperPlayer
mkFields ''RelSuperPlayer

tableContext :: TableContext
tableContext = TableContext
    relSuperPlayer
    officeId
    officeId'
    "rel_super_player"
    "office_id"
    fields
