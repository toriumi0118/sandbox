{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelFemaleDay where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_female_day"
deriveJSON defaultOptions ''RelFemaleDay
mkFields ''RelFemaleDay

tableContext :: TableContext RelFemaleDay
tableContext = TableContext
    relFemaleDay
    officeId
    officeId'
    "rel_female_day"
    "office_id"
    fields
    NoParam
