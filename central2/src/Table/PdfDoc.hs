{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.PdfDoc where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "pdf_doc"
deriveJSON defaultOptions ''PdfDoc
mkFields ''PdfDoc

tableContext :: TableContext PdfDoc
tableContext = TableContext
    pdfDoc
    id
    id'
    "pdf_doc"
    "id"
    fields
    NoParam
