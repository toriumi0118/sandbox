{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbAdditionalSrv where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_additional_srv"
deriveJSON defaultOptions ''RelSbAdditionalSrv
mkFields ''RelSbAdditionalSrv

tableContext :: TableContext RelSbAdditionalSrv
tableContext = TableContext
    relSbAdditionalSrv
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_additional_srv"
    "sb_id"
    fields
    NoParam
