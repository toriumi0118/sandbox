{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbPayMethod where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_pay_method"
deriveJSON defaultOptions ''RelSbPayMethod
mkFields ''RelSbPayMethod

tableContext :: TableContext RelSbPayMethod
tableContext = TableContext
    relSbPayMethod
    sbId
    sbId'
    "rel_sb_pay_method"
    "sb_id"
    fields
    NoParam
