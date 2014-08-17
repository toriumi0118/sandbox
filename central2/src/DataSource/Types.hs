{-# LANGUAGE ExistentialQuantification #-}

module DataSource.Types
    ( Connection(..)
    ) where

import Control.Applicative

import Database.HDBC (IConnection(..))

data Connection = forall a . IConnection a => Connection a

instance IConnection Connection where
    disconnect (Connection c) = disconnect c
    commit (Connection c) = commit c
    rollback (Connection c) = rollback c
    runRaw (Connection c) = runRaw c
    run (Connection c) = run c
    prepare (Connection c) = prepare c
    clone (Connection c) = Connection <$> clone c
    hdbcDriverName (Connection c) = hdbcDriverName c
    hdbcClientVer (Connection c) = hdbcClientVer c
    proxiedClientName (Connection c) = proxiedClientName c
    proxiedClientVer (Connection c) = proxiedClientVer c
    dbServerVer (Connection c) = dbServerVer c
    dbTransactionSupport (Connection c) = dbTransactionSupport c
    getTables (Connection c) = getTables c
    describeTable (Connection c) = describeTable c
