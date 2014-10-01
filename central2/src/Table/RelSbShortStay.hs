{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbShortStay where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_short_stay"
deriveJSON defaultOptions ''RelSbShortStay
mkFields ''RelSbShortStay

tableContext :: TableContext RelSbShortStay
tableContext = TableContext
    relSbShortStay
    sbId
    sbId'
    "rel_sb_short_stay"
    "sb_id"
    fields
    NoParam
