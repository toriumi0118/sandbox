
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeUserInfo where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "office_user_info"
deriveJSON defaultOptions ''OfficeUserInfo
mkFields ''OfficeUserInfo

tableContext :: TableContext
tableContext = TableContext
    officeUserInfo
    officeId
    officeId'
    "office_user_info"
    "office_id"
    fields
