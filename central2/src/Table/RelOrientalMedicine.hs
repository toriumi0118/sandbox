{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelOrientalMedicine where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_oriental_medicine"
deriveJSON defaultOptions ''RelOrientalMedicine
mkFields ''RelOrientalMedicine

tableContext :: TableContext RelOrientalMedicine
tableContext = TableContext
    relOrientalMedicine
    officeId
    officeId'
    "rel_oriental_medicine"
    "office_id"
    fields
    Nothing
