
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHead where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "news_head"
deriveJSON defaultOptions ''NewsHead
mkFields ''NewsHead

tableContext :: TableContext NewsHead
tableContext = TableContext
    newsHead
    id
    id'
    "news_head"
    "id"
    fields
