{-# LANGUAGE FlexibleContexts #-}

module Controller.Version
    ( versionupInfo
    ) where

import Control.Applicative
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.State (StateT)
import qualified Control.Monad.Trans.State as State
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Int (Int64)
import Data.Map (Map)
import qualified Data.Map as Map
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query
import Safe (headMay)
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

import Auth (Auth)
import DataSource (Connection)
import qualified Query
import qualified Table.OfficeHistory as OfficeHis
import qualified Table.KyotakuHistory as KyotakuHis
import qualified Table.NewsHistory as NewsHis
import qualified Table.Version as Version
import Util (fromJustM)

versionOrd :: Relation () Version.Version
versionOrd = relation $ do
    v <- query Version.version
    asc $ v ! Version.prcDate'
    return v

recent :: Relation () a -> Pi a Int64 -> Relation () a
recent r k = relation $ do
    h <- query r
    desc $ h ! k
    return h

recentHis :: (FromSql SqlValue a)
    => Connection -> Relation () a -> Pi a Int64 -> IO (Maybe a)
recentHis conn rel k =
    headMay <$> Query.runQuery conn (recent rel k) ()

insertIfNotNull :: ToJSON a
    => String -> Maybe a -> StateT (Map String Value) IO ()
insertIfNotNull name = fromJustM $ State.modify . Map.insert name . toJSON

storeRecentHis :: (FromSql SqlValue a, ToJSON a)
    => Connection -> String -> Relation () a -> Pi a Int64
    -> StateT (Map String Value) IO ()
storeRecentHis conn name rel k = do
    his <- lift $ recentHis conn rel k
    insertIfNotNull name his

getHisIds :: Connection -> IO (Map String Value)
getHisIds conn = flip State.execStateT Map.empty $ do
    storeRecentHis conn "officeId" OfficeHis.officeHistory OfficeHis.id'
    storeRecentHis conn "kyotakuId" KyotakuHis.kyotakuHistory KyotakuHis.id'
    storeRecentHis conn "newsHeadId" NewsHis.newsHistory NewsHis.id'

    undefined

versionupInfo :: Auth -> ActionM ()
versionupInfo _ = do
    (vs, hs) <- Query.query $ \conn -> (,)
        <$> Query.runQuery conn versionOrd ()
        <*> getHisIds conn
    let r = Map.fromList
            [ (versionsKey, toJSON vs)
            , ("dataHisIds", toJSON hs)
            ]
    Scotty.json r
  where
    versionsKey :: String
    versionsKey = "versions"
