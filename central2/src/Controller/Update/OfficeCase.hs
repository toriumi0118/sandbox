module Controller.Update.OfficeCase
    ( updateData
    ) where

import qualified Table.OfficeCaseRel
import qualified Table.OfficePdf
import Table.Types (TableContext)

updateData :: [TableContext]
updateData =
    [ Table.OfficePdf.tableContext
    , Table.OfficeCaseRel.tableContext
    ]
