{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbPalliativeCare where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_palliative_care"
deriveJSON defaultOptions ''RelSbPalliativeCare
mkFields ''RelSbPalliativeCare

tableContext :: TableContext RelSbPalliativeCare
tableContext = TableContext
    relSbPalliativeCare
    sbId
    sbId'
    "rel_sb_palliative_care"
    "sb_id"
    fields
    NoParam
