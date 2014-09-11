
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeAppealPoint where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office_appeal_point"
deriveJSON defaultOptions ''OfficeAppealPoint
mkFields ''OfficeAppealPoint

tableContext :: TableContext OfficeAppealPoint
tableContext = TableContext
    officeAppealPoint
    officeId
    officeId'
    "office_appeal_point"
    "office_id"
    fields
    Nothing
