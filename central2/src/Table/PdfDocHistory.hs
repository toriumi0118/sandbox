{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.PdfDocHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class (History)
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import DataSource (defineTable)

defineTable "pdf_doc_history"

deriveJSON defaultOptions ''PdfDocHistory

instance History PdfDocHistory

historyContext :: HistoryContext PdfDocHistory
historyContext = HistoryContext
    pdfDocHistory
    id'
    V.pdfDocId
