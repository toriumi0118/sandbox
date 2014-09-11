{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelNight where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_night"
deriveJSON defaultOptions ''RelNight
mkFields ''RelNight

tableContext :: TableContext RelNight
tableContext = TableContext
    relNight
    officeId
    officeId'
    "rel_night"
    "office_id"
    fields
    Nothing
