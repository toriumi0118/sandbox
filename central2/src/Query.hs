{-# LANGUAGE FlexibleContexts #-}

module Query
    ( runQuery
    , query
    , update
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Database.HDBC (IConnection(..), SqlValue, commit)
import qualified Database.HDBC.Record.Query as Q
import Database.HDBC.Session (withConnectionIO, handleSqlError')
import Database.Record (FromSql, ToSql)
import Database.Relational.Query (Relation, relationalQuery)

import DataSource (connect, Connection)

runQuery :: (MonadIO m, IConnection conn, ToSql SqlValue p, FromSql SqlValue a)
    => conn -> Relation p a -> p -> m [a]
runQuery conn relation =
    liftIO . Q.runQuery conn (relationalQuery relation)

query :: MonadIO m => (Connection -> IO a) -> m a
query =
    liftIO . handleSqlError' . withConnectionIO connect

update :: MonadIO m => (Connection -> IO a) -> m a
update f = query $ \conn -> do
    r <- f conn
    commit conn
    return r
