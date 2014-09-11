
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSocialAid where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_social_aid"
deriveJSON defaultOptions ''RelSocialAid
mkFields ''RelSocialAid

tableContext :: TableContext RelSocialAid
tableContext = TableContext
    relSocialAid
    officeId
    officeId'
    "rel_social_aid"
    "office_id"
    fields
    Nothing
