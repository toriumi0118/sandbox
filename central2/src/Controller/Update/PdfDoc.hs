{-# LANGUAGE FlexibleContexts #-}

module Controller.Update.PdfDoc
    ( updateData
    ) where

import Control.Monad.IO.Class (MonadIO)

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
import qualified Table.PdfDoc
import qualified Table.PdfDocRel

updateData :: (MonadIO m, Functor m) => UpdatedDataList m ()
updateData = do
    updatedData Table.PdfDoc.tableContext
    updatedData Table.PdfDocRel.tableContext
