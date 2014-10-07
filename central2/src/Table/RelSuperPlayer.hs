{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSuperPlayer where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_super_player"
deriveJSON defaultOptions ''RelSuperPlayer
mkFields ''RelSuperPlayer

tableContext :: TableContext RelSuperPlayer
tableContext = TableContext
    relSuperPlayer
    officeId
    officeId'
    "rel_super_player"
    "office_id"
    fields
    NoParam
