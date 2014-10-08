{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeImageCom where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Database.Relational.Query ((|$|))

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office_image_com"
deriveJSON defaultOptions ''OfficeImageCom
mkFields ''OfficeImageCom

tableContext :: TableContext OfficeImageCom
tableContext = TableContext
    officeImageCom
    (fromIntegral . officeId)
    (fromIntegral |$| officeId')
    "office_image_com"
    "office_id"
    fields
    NoParam
