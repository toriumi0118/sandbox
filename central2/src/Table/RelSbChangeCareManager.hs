{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbChangeCareManager where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_change_care_manager"
deriveJSON defaultOptions ''RelSbChangeCareManager
mkFields ''RelSbChangeCareManager

tableContext :: TableContext RelSbChangeCareManager
tableContext = TableContext
    relSbChangeCareManager
    sbId
    sbId'
    "rel_sb_change_care_manager"
    "sb_id"
    fields
    NoParam
