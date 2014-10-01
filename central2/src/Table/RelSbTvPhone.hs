{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbTvPhone where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_tv_phone"
deriveJSON defaultOptions ''RelSbTvPhone
mkFields ''RelSbTvPhone

tableContext :: TableContext RelSbTvPhone
tableContext = TableContext
    relSbTvPhone
    sbId
    sbId'
    "rel_sb_tv_phone"
    "sb_id"
    fields
    NoParam
