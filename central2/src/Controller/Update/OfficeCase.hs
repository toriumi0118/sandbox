{-# LANGUAGE FlexibleContexts #-}

module Controller.Update.OfficeCase
    ( updateData
    ) where

import Control.Monad.IO.Class (MonadIO)

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
import qualified Table.OfficeCaseRel
import qualified Table.OfficePdf

updateData :: (MonadIO m, Functor m) => UpdatedDataList m ()
updateData = do
    updatedData Table.OfficePdf.tableContext
    updatedData Table.OfficeCaseRel.tableContext
