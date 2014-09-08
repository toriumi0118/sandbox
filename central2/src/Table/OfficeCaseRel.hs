
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeCaseRel where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_case_rel"
deriveJSON defaultOptions ''OfficeCaseRel
mkFields ''OfficeCaseRel

tableContext :: TableContext
tableContext = TableContext
    officeCaseRel
    (fromIntegral . officePdfId)
    (fromIntegral |$| officePdfId')
    "office_case_rel"
    "office_pdf_id"
    fields
