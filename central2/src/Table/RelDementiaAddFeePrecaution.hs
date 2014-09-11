
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaAddFeePrecaution where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_add_fee_precaution"
deriveJSON defaultOptions ''RelDementiaAddFeePrecaution
mkFields ''RelDementiaAddFeePrecaution

tableContext :: TableContext RelDementiaAddFeePrecaution
tableContext = TableContext
    relDementiaAddFeePrecaution
    officeId
    officeId'
    "rel_dementia_add_fee_precaution"
    "office_id"
    fields
    Nothing
