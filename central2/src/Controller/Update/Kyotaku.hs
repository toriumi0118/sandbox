module Controller.Update.Kyotaku
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, DataProvider(Default), updatedData)
import qualified Table.Kyotaku
import qualified Table.KyotakuBusinessTime
import qualified Table.KyotakuLicense
import qualified Table.RelKyotakuCareAddFeeOther
import qualified Table.RelKyotakuCareAddFeeService
import qualified Table.RelKyotakuCareAddFeeStaff
import qualified Table.RelKyotakuServiceArea
import qualified Table.RelKyotakuTellEmergency

updateData :: UpdatedDataList
updateData conn hs =
    [ updatedData Default conn hs Table.Kyotaku.tableContext
    , updatedData Default conn hs Table.KyotakuLicense.tableContext
    , updatedData Default conn hs Table.RelKyotakuServiceArea.tableContext
    , updatedData Default conn hs Table.RelKyotakuCareAddFeeStaff.tableContext
    , updatedData Default conn hs Table.RelKyotakuCareAddFeeService.tableContext
    , updatedData Default conn hs Table.RelKyotakuCareAddFeeOther.tableContext
    , updatedData Default conn hs Table.RelKyotakuTellEmergency.tableContext
    , updatedData Default conn hs Table.KyotakuBusinessTime.tableContext
    ]
