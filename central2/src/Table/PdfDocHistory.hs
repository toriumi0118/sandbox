{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.PdfDocHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import qualified Controller.Types.VersionupHisIds as V
import Controller.Update.HistoryContext (HistoryContext(HistoryContext), History(History))
import DataSource (defineTable)

defineTable "pdf_doc_history"

deriveJSON defaultOptions ''PdfDocHistory

historyContext :: HistoryContext PdfDocHistory
historyContext = HistoryContext
    pdfDocHistory
    id'
    V.pdfDocId
    (\h -> History (id h) (pdfDocId h) (Just $ pdfDocId h) (read $ action h) (Just $ filePath h) Nothing)
