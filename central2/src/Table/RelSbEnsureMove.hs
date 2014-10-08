{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbEnsureMove where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_ensure_move"
deriveJSON defaultOptions ''RelSbEnsureMove
mkFields ''RelSbEnsureMove

tableContext :: TableContext RelSbEnsureMove
tableContext = TableContext
    relSbEnsureMove
    sbId
    sbId'
    "rel_sb_ensure_move"
    "sb_id"
    fields
    NoParam
