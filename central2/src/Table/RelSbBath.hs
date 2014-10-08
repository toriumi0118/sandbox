{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbBath where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_bath"
deriveJSON defaultOptions ''RelSbBath
mkFields ''RelSbBath

tableContext :: TableContext RelSbBath
tableContext = TableContext
    relSbBath
    sbId
    sbId'
    "rel_sb_bath"
    "sb_id"
    fields
    NoParam
