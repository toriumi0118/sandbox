{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbRoomPrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_room_price"
deriveJSON defaultOptions ''RelSbRoomPrice
mkFields ''RelSbRoomPrice

tableContext :: TableContext RelSbRoomPrice
tableContext = TableContext
    relSbRoomPrice
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_room_price"
    "sb_id"
    fields
    NoParam
