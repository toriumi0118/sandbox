
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelExperiencePrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_experience_price"
deriveJSON defaultOptions ''RelExperiencePrice
mkFields ''RelExperiencePrice

tableContext :: TableContext RelExperiencePrice
tableContext = TableContext
    relExperiencePrice
    officeId
    officeId'
    "rel_experience_price"
    "office_id"
    fields
