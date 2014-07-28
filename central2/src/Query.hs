{-# LANGUAGE FlexibleContexts #-}

module Query
    ( runQuery
    , execQuery
    , execUpdate
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Database.HDBC (IConnection, SqlValue, commit)
import qualified Database.HDBC.Record.Query as Q
import Database.HDBC.Session (withConnectionIO, handleSqlError')
import Database.Record (FromSql, ToSql)
import Database.Relational.Query (Relation, relationalQuery)

runQuery :: (IConnection conn, ToSql SqlValue p, FromSql SqlValue a)
    => conn -> Relation p a -> p -> IO [a]
runQuery conn relation params =
    Q.runQuery conn (relationalQuery relation) params

execQuery :: (IConnection conn, MonadIO m)
    => IO conn -> (conn -> IO a) -> m a
execQuery conn =
    liftIO . handleSqlError' . withConnectionIO conn

execUpdate :: (IConnection conn, MonadIO m)
    => IO conn -> (conn -> IO a) -> m a
execUpdate conn body = execQuery conn $ \c -> do
    r <- body c
    commit c
    return r
