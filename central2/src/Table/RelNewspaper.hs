
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelNewspaper where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_newspaper"
deriveJSON defaultOptions ''RelNewspaper
mkFields ''RelNewspaper

tableContext :: TableContext RelNewspaper
tableContext = TableContext
    relNewspaper
    officeId
    officeId'
    "rel_newspaper"
    "office_id"
    fields
    Nothing
