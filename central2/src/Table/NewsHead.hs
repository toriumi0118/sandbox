
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHead where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NewsParam))
import DataSource (defineTable)
import qualified Query
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
    (NewsParam $ Query.between newsHead dateYmd')
