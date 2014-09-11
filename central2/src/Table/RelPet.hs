{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelPet where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_pet"
deriveJSON defaultOptions ''RelPet
mkFields ''RelPet

tableContext :: TableContext RelPet
tableContext = TableContext
    relPet
    officeId
    officeId'
    "rel_pet"
    "office_id"
    fields
    Nothing
