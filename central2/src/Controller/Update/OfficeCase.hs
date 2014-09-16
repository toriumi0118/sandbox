{-# LANGUAGE FlexibleContexts #-}

module Controller.Update.OfficeCase
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
import qualified Table.OfficeCaseRel
import qualified Table.OfficePdf

updateData :: UpdatedDataList
updateData =
    [ updatedData Table.OfficePdf.tableContext
    , updatedData Table.OfficeCaseRel.tableContext
    ]
