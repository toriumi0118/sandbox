{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbRoutineSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_routine_srv"
deriveJSON defaultOptions ''RelSbRoutineSrv
mkFields ''RelSbRoutineSrv

tableContext :: TableContext RelSbRoutineSrv
tableContext = TableContext
    relSbRoutineSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_routine_srv"
    "sb_id"
    fields
    NoParam
