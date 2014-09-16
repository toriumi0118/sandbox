{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.PdfDocRel where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "pdf_doc_rel"
deriveJSON defaultOptions ''PdfDocRel
mkFields ''PdfDocRel

tableContext :: TableContext PdfDocRel
tableContext = TableContext
    pdfDocRel
    pdfDocId
    pdfDocId'
    "pdf_doc_rel"
    "pdf_doc_id"
    fields
    NoParam
