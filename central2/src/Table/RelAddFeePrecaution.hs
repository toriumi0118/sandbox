
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFeePrecaution where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_add_fee_precaution"
deriveJSON defaultOptions ''RelAddFeePrecaution
mkFields ''RelAddFeePrecaution

tableContext :: TableContext RelAddFeePrecaution
tableContext = TableContext
    relAddFeePrecaution
    officeId
    officeId'
    "rel_add_fee_precaution"
    "office_id"
    fields
