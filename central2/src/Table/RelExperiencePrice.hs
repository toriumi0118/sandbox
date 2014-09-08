
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelExperiencePrice where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_experience_price"
deriveJSON defaultOptions ''RelExperiencePrice
mkFields ''RelExperiencePrice

tableContext :: TableContext
tableContext = TableContext
    relExperiencePrice
    officeId
    officeId'
    "rel_experience_price"
    "office_id"
    fields
