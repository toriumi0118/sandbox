{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.Topic where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO)
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Int (Int32)
import Prelude hiding (id)
import qualified Safe

import Controller.Types.Class ()
import Controller.Types.OfficeType (OfficeType(..))
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(TopicParam), Position(Pos), pos)
import DataSource (Connection, defineTable)
import qualified Query
import qualified Table.Office as O
import qualified Table.ServiceBuilding as SB
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

f :: (MonadIO m, Functor m)
    => Connection -> m (Maybe Position) -> Topic -> m Bool
f _    _    (Topic _ _ _ _ _ _ _ Nothing _) =
    fail "topic type is NULL"
f conn kPos tp = kPos >>= maybe kyotakuIsNull (g conn tp)
  where
    kyotakuIsNull = return False

hubenyDist :: Position -> Position -> Double
hubenyDist (Pos lat1 lon1) (Pos lat2 lon2) = sqrt $ dym ^ 2 + dxncos ^ 2
  where
    a = 6378137.000
    e2 = 0.00669438002301188
    mnum = 6335439.32708317
    deg2rad deg = deg * pi / 180
    my = deg2rad $ (lat1 + lat2) / 2
    dy = deg2rad $ lat1 - lat2
    dx = deg2rad $ lon1 - lon2
    si = sin my
    w = sqrt $ 1.0 - e2 * si ^ 2
    m = mnum / w ^ 3
    n = a / w
    dym = dy * m
    dxncos = dx * n * cos my

g :: (MonadIO m, Functor m) => Connection -> Topic -> Position -> m Bool
g _    (Topic tid _ _ _ _ Nothing    _ (Just 0) _        ) _    =
    fail $ "topic.office_id is NULL: topic.id=" ++ show tid
g _    (Topic tid _ _ _ _ _          _ (Just 0) Nothing  ) _    =
    fail $ "topic.office_type is NULL: topic.id=" ++ show tid
g conn (Topic _   _ _ _ _ (Just oid) _ (Just 0) (Just ot)) kpos = do
    opos <- case Safe.readMay ot of
        Just DayService      ->
            toPos O.latitude O.longitude O.office O.officeId'
        Just ServiceBuilding ->
            toPos SB.latitude SB.longitude SB.serviceBuilding SB.sbId'
        Nothing -> fail $ "unknown topic.office_type=" ++ ot
    maybe
        (fail $ "office positon not found: office_id=" ++ show oid ++ " office_type=" ++ ot)
        (return . (<= 10000) . flip hubenyDist kpos)
        opos
  where
    toPos lat lon rel k = pos lat lon . Safe.headMay
        <$> Query.runQuery conn (Query.byKey rel k) (fromIntegral oid)
g _    (Topic _   _ _ _ _ _          _ (Just _) _        ) _    =
    return True
g _    (Topic tid _ _ _ _ _          _ Nothing  _        ) _    =
    fail $ "not reached: topic type is NULL: topic.id=" ++ show tid
