
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeImageCom where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_image_com"
deriveJSON defaultOptions ''OfficeImageCom
mkFields ''OfficeImageCom

tableContext :: TableContext
tableContext = TableContext
    officeImageCom
    (fromIntegral . officeId)
    (fromIntegral |$| officeId')
    "office_image_com"
    "office_id"
    fields
