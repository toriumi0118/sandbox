{-# LANGUAGE FlexibleContexts #-}

module Query
    ( runQuery
    , query
    , update
    , inList
    , byKey
    , between
    ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Database.HDBC (IConnection(..), SqlValue, commit)
import qualified Database.HDBC.Record.Query as RQ
import Database.HDBC.Session (withConnectionIO, handleSqlError')
import Database.Record (FromSql, ToSql, PersistableWidth)
import Database.Relational.Query (Relation, Pi, ShowConstantTermsSQL, (!), (.=.), (.<.), (.<=.), in', and')
import qualified Database.Relational.Query as Q

import DataSource (connect, Connection)

runQuery :: (MonadIO m, IConnection conn, ToSql SqlValue p, FromSql SqlValue a)
    => conn -> Relation p a -> p -> m [a]
runQuery conn relation =
    liftIO . RQ.runQuery conn (Q.relationalQuery relation)

query :: MonadIO m => (Connection -> IO a) -> m a
query =
    liftIO . handleSqlError' . withConnectionIO connect

update :: MonadIO m => (Connection -> IO a) -> m a
update f = query $ \conn -> do
    r <- f conn
    commit conn
    return r

-- utilities

inList :: (Integral i, Num j, ShowConstantTermsSQL j, PersistableWidth k)
    => Relation k a -> Pi a j -> [i] -> Relation k a
inList rel k ids = Q.relation' $ do
    (ph, o) <- Q.query' rel
    Q.wheres $ o ! k `in'` Q.values (map fromIntegral ids)
    Q.asc $ o ! k
    return (ph, o)

byKey :: PersistableWidth k => Relation () a -> Pi a k -> Relation k a
byKey rel k = Q.relation' $ do
    a <- Q.query rel
    (ph, ()) <- Q.placeholder $ \k' -> Q.wheres $
        a ! k .=. k'
    return (ph, a)

between :: PersistableWidth k => Relation () a -> Pi a k -> Relation (k, k) a
between rel k = Q.relation' $ do
    a <- Q.query rel
    (ph, ()) <- Q.placeholder $ \range -> Q.wheres $
        (range ! Q.fst' .<. a ! k) `and'`
        (a ! k .<=. range ! Q.snd')
    return (ph, a)
