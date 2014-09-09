module Controller.Update.OfficeCase
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, DataProvider(Default), updatedData)
import qualified Table.OfficeCaseRel
import qualified Table.OfficePdf

updateData :: UpdatedDataList
updateData conn hs =
    [ updatedData Default conn hs Table.OfficePdf.tableContext
    , updatedData Default conn hs Table.OfficeCaseRel.tableContext
    ]
