{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBathJet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_bath_jet"
deriveJSON defaultOptions ''RelBathJet
mkFields ''RelBathJet

tableContext :: TableContext RelBathJet
tableContext = TableContext
    relBathJet
    officeId
    officeId'
    "rel_bath_jet"
    "office_id"
    fields
    Nothing
