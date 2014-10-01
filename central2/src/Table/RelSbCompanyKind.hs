{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelSbCompanyKind where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_sb_company_kind"
deriveJSON defaultOptions ''RelSbCompanyKind
mkFields ''RelSbCompanyKind

tableContext :: TableContext RelSbCompanyKind
tableContext = TableContext
    relSbCompanyKind
    sbId
    sbId'
    "rel_sb_company_kind"
    "sb_id"
    fields
    NoParam
