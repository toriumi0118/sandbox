{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.SbEnsureMoveDetail where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "sb_ensure_move_detail"
deriveJSON defaultOptions ''SbEnsureMoveDetail
mkFields ''SbEnsureMoveDetail

tableContext :: TableContext SbEnsureMoveDetail
tableContext = TableContext
    sbEnsureMoveDetail
    sbId
    sbId'
    "sb_ensure_move_detail"
    "sb_id"
    fields
    NoParam
