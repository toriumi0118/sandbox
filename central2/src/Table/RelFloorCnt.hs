
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFloorCnt where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_floor_cnt"
deriveJSON defaultOptions ''RelFloorCnt
mkFields ''RelFloorCnt

tableContext :: TableContext
tableContext = TableContext
    relFloorCnt
    officeId
    officeId'
    "rel_floor_cnt"
    "office_id"
    fields
