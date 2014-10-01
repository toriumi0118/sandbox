{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbDrinkingArea where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_drinking_area"
deriveJSON defaultOptions ''RelSbDrinkingArea
mkFields ''RelSbDrinkingArea

tableContext :: TableContext RelSbDrinkingArea
tableContext = TableContext
    relSbDrinkingArea
    sbId
    sbId'
    "rel_sb_drinking_area"
    "sb_id"
    fields
    NoParam
