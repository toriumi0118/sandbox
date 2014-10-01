{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbSprinkler where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_sprinkler"
deriveJSON defaultOptions ''RelSbSprinkler
mkFields ''RelSbSprinkler

tableContext :: TableContext RelSbSprinkler
tableContext = TableContext
    relSbSprinkler
    sbId
    sbId'
    "rel_sb_sprinkler"
    "sb_id"
    fields
    NoParam
