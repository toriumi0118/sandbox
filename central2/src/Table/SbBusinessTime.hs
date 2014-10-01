{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.SbBusinessTime where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "sb_business_time"
deriveJSON defaultOptions ''SbBusinessTime
mkFields ''SbBusinessTime

tableContext :: TableContext SbBusinessTime
tableContext = TableContext
    sbBusinessTime
    sbId
    sbId'
    "sb_business_time"
    "sb_id"
    fields
    NoParam
