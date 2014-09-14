{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.PdfDocHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import DataSource (defineTable)

defineTable "pdf_doc_history"

deriveJSON defaultOptions ''PdfDocHistory
