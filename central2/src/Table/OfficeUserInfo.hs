
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeUserInfo where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office_user_info"
deriveJSON defaultOptions ''OfficeUserInfo
mkFields ''OfficeUserInfo

tableContext :: TableContext OfficeUserInfo
tableContext = TableContext
    officeUserInfo
    officeId
    officeId'
    "office_user_info"
    "office_id"
    fields
