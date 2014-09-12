{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelElevator where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_elevator"
deriveJSON defaultOptions ''RelElevator
mkFields ''RelElevator

tableContext :: TableContext RelElevator
tableContext = TableContext
    relElevator
    officeId
    officeId'
    "rel_elevator"
    "office_id"
    fields
    NoParam
