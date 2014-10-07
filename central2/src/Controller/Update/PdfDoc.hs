{-# LANGUAGE FlexibleContexts #-}

module Controller.Update.PdfDoc
    ( updateData
    ) where

import Control.Monad.IO.Class (MonadIO)

import Controller.Update.DataProvider (DataProvider)
import Controller.Update.UpdateData (updatedData)
import qualified Table.PdfDoc
import qualified Table.PdfDocRel

updateData :: (MonadIO m, Functor m) => DataProvider m ()
updateData = do
    updatedData Table.PdfDoc.tableContext
    updatedData Table.PdfDocRel.tableContext
