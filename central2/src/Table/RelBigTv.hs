
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelBigTv where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_big_tv"
deriveJSON defaultOptions ''RelBigTv
mkFields ''RelBigTv

tableContext :: TableContext
tableContext = TableContext
    relBigTv
    officeId
    officeId'
    "rel_big_tv"
    "office_id"
    fields
