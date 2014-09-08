
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficePdf where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_pdf"
deriveJSON defaultOptions ''OfficePdf
mkFields ''OfficePdf

tableContext :: TableContext
tableContext = TableContext
    officePdf
    (fromIntegral . id)
    (fromIntegral |$| id')
    "office_pdf"
    "id"
    fields
