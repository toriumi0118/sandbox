{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Topic where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Int (Int32)
import Prelude hiding (id)

import Controller.Types.Class ()
import Controller.Types.OfficeType (OfficeType)
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(TopicParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "topic"
deriveJSON defaultOptions ''Topic
mkFields ''Topic

tableContext :: Maybe Int32 -> TableContext Topic
tableContext devideId = TableContext
    topic
    id
    id'
    "topic"
    "id"
    fields
    (TopicParam devideId f)

f :: Maybe (Double, Double) -> Topic -> Bool
f _                 (Topic _ _ _ _ _ _ _ Nothing  _)  =
    error "type is NULL"
f (Just (lat, lon)) (Topic _ _ _ _ _ _ _ (Just 0) _)  =
    undefined
f Nothing           (Topic _ _ _ _ _ _ _ (Just 0) _)  = False -- log
f _                 t                                 = True
