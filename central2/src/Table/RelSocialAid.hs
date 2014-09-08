
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSocialAid where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_social_aid"
deriveJSON defaultOptions ''RelSocialAid
mkFields ''RelSocialAid

tableContext :: TableContext
tableContext = TableContext
    relSocialAid
    officeId
    officeId'
    "rel_social_aid"
    "office_id"
    fields
