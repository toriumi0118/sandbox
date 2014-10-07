{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbInfirm where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_infirm"
deriveJSON defaultOptions ''RelSbInfirm
mkFields ''RelSbInfirm

tableContext :: TableContext RelSbInfirm
tableContext = TableContext
    relSbInfirm
    sbId
    sbId'
    "rel_sb_infirm"
    "sb_id"
    fields
    NoParam
