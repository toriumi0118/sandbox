{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelAddFee where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_add_fee"
deriveJSON defaultOptions ''RelAddFee
mkFields ''RelAddFee

tableContext :: TableContext RelAddFee
tableContext = TableContext
    relAddFee
    officeId
    officeId'
    "rel_add_fee"
    "office_id"
    fields
    NoParam
