{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbArchitecture where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_architecture"
deriveJSON defaultOptions ''RelSbArchitecture
mkFields ''RelSbArchitecture

tableContext :: TableContext RelSbArchitecture
tableContext = TableContext
    relSbArchitecture
    sbId
    sbId'
    "rel_sb_architecture"
    "sb_id"
    fields
    NoParam
