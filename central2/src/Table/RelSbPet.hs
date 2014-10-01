{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbPet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_pet"
deriveJSON defaultOptions ''RelSbPet
mkFields ''RelSbPet

tableContext :: TableContext RelSbPet
tableContext = TableContext
    relSbPet
    sbId
    sbId'
    "rel_sb_pet"
    "sb_id"
    fields
    NoParam
