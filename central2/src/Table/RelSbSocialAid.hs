{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbSocialAid where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_social_aid"
deriveJSON defaultOptions ''RelSbSocialAid
mkFields ''RelSbSocialAid

tableContext :: TableContext RelSbSocialAid
tableContext = TableContext
    relSbSocialAid
    sbId
    sbId'
    "rel_sb_social_aid"
    "sb_id"
    fields
    NoParam
