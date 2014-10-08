
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsHead where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import qualified Data.Time as Time
import Prelude hiding (id)
import System.Locale (defaultTimeLocale)

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
    (NewsParam (Query.between newsHead dateYmd') param)
  where
    param = do
        to <- Time.getZonedTime
        let (Time.UTCTime day diff) = Time.zonedTimeToUTC to
        let sut = Time.UTCTime (Time.addDays (-180) day) diff
        from <- Time.utcToLocalZonedTime sut
        return (f from, f to)
      where
        fmt = "%0C%y%m%d"
        f = Just . read . Time.formatTime defaultTimeLocale fmt
