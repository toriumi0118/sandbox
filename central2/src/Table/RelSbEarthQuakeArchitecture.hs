{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbEarthQuakeArchitecture where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_earth_quake_architecture"
deriveJSON defaultOptions ''RelSbEarthQuakeArchitecture
mkFields ''RelSbEarthQuakeArchitecture

tableContext :: TableContext RelSbEarthQuakeArchitecture
tableContext = TableContext
    relSbEarthQuakeArchitecture
    sbId
    sbId'
    "rel_sb_earth_quake_architecture"
    "sb_id"
    fields
    NoParam
