{-# LANGUAGE FlexibleContexts #-}

module Controller.Update.Kyotaku
    ( updateData
    ) where

import Control.Monad.IO.Class (MonadIO)

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
import qualified Table.Kyotaku
import qualified Table.KyotakuBusinessTime
import qualified Table.KyotakuLicense
import qualified Table.RelKyotakuCareAddFeeOther
import qualified Table.RelKyotakuCareAddFeeService
import qualified Table.RelKyotakuCareAddFeeStaff
import qualified Table.RelKyotakuServiceArea
import qualified Table.RelKyotakuTellEmergency

updateData :: (MonadIO m, Functor m) => UpdatedDataList m ()
updateData = do
    updatedData Table.Kyotaku.tableContext
    updatedData Table.KyotakuLicense.tableContext
    updatedData Table.RelKyotakuServiceArea.tableContext
    updatedData Table.RelKyotakuCareAddFeeStaff.tableContext
    updatedData Table.RelKyotakuCareAddFeeService.tableContext
    updatedData Table.RelKyotakuCareAddFeeOther.tableContext
    updatedData Table.RelKyotakuTellEmergency.tableContext
    updatedData Table.KyotakuBusinessTime.tableContext
