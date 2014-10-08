{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbSmokingArea where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_smoking_area"
deriveJSON defaultOptions ''RelSbSmokingArea
mkFields ''RelSbSmokingArea

tableContext :: TableContext RelSbSmokingArea
tableContext = TableContext
    relSbSmokingArea
    sbId
    sbId'
    "rel_sb_smoking_area"
    "sb_id"
    fields
    NoParam
