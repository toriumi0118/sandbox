module Controller.Update.Kyotaku
    ( updateData
    ) where

import qualified Table.Kyotaku
import qualified Table.KyotakuBusinessTime
import qualified Table.KyotakuLicense
import qualified Table.RelKyotakuCareAddFeeOther
import qualified Table.RelKyotakuCareAddFeeService
import qualified Table.RelKyotakuCareAddFeeStaff
import qualified Table.RelKyotakuServiceArea
import qualified Table.RelKyotakuTellEmergency
import Table.Types (TableContext)

updateData :: [TableContext]
updateData =
    [ Table.Kyotaku.tableContext
    , Table.KyotakuLicense.tableContext
    , Table.RelKyotakuServiceArea.tableContext
    , Table.RelKyotakuCareAddFeeStaff.tableContext
    , Table.RelKyotakuCareAddFeeService.tableContext
    , Table.RelKyotakuCareAddFeeOther.tableContext
    , Table.RelKyotakuTellEmergency.tableContext
    , Table.KyotakuBusinessTime.tableContext
    ]
