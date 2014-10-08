{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbRoomFacility where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_room_facility"
deriveJSON defaultOptions ''RelSbRoomFacility
mkFields ''RelSbRoomFacility

tableContext :: TableContext RelSbRoomFacility
tableContext = TableContext
    relSbRoomFacility
    (fromIntegral . sbId)
    (fromIntegral |$| sbId')
    "rel_sb_room_facility"
    "sb_id"
    fields
    NoParam
