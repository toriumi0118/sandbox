module Controller.Update.OfficeCase
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
import qualified Table.OfficeCaseRel
import qualified Table.OfficePdf

updateData :: UpdatedDataList
updateData conn hs =
    [ updatedData conn hs Table.OfficePdf.tableContext
    , updatedData conn hs Table.OfficeCaseRel.tableContext
    ]
