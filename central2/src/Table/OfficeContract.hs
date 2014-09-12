{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeContract where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "office_contract"
deriveJSON defaultOptions ''OfficeContract
mkFields ''OfficeContract

tableContext :: TableContext OfficeContract
tableContext = TableContext
    officeContract
    officeId
    officeId'
    "office_contract"
    "office_id"
    fields
    NoParam
