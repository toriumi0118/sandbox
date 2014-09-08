
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelStayNight where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_stay_night"
deriveJSON defaultOptions ''RelStayNight
mkFields ''RelStayNight

tableContext :: TableContext
tableContext = TableContext
    relStayNight
    officeId
    officeId'
    "rel_stay_night"
    "office_id"
    fields
