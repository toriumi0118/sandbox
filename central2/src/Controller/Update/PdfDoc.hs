module Controller.Update.PdfDoc
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
import qualified Table.PdfDoc
import qualified Table.PdfDocRel

updateData :: UpdatedDataList
updateData conn hs =
    [ updatedData conn hs Table.PdfDoc.tableContext
    , updatedData conn hs Table.PdfDocRel.tableContext
    ]
