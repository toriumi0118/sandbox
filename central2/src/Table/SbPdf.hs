{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.SbPdf where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "sb_pdf"
deriveJSON defaultOptions ''SbPdf
mkFields ''SbPdf

tableContext :: TableContext SbPdf
tableContext = TableContext
    sbPdf
    (fromIntegral . id)
    (fromIntegral |$| id')
    "sb_pdf"
    "id"
    fields
    NoParam
