module Controller.Update.Kyotaku
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
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
    [ updatedData conn hs Table.Kyotaku.tableContext
    , updatedData conn hs Table.KyotakuLicense.tableContext
    , updatedData conn hs Table.RelKyotakuServiceArea.tableContext
    , updatedData conn hs Table.RelKyotakuCareAddFeeStaff.tableContext
    , updatedData conn hs Table.RelKyotakuCareAddFeeService.tableContext
    , updatedData conn hs Table.RelKyotakuCareAddFeeOther.tableContext
    , updatedData conn hs Table.RelKyotakuTellEmergency.tableContext
    , updatedData conn hs Table.KyotakuBusinessTime.tableContext
    ]
