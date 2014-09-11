
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFloorCnt where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_floor_cnt"
deriveJSON defaultOptions ''RelFloorCnt
mkFields ''RelFloorCnt

tableContext :: TableContext RelFloorCnt
tableContext = TableContext
    relFloorCnt
    officeId
    officeId'
    "rel_floor_cnt"
    "office_id"
    fields
    Nothing
