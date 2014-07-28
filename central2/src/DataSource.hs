module DataSource
    ( connect
    ) where

import Control.Applicative
import Database.HDBC.PostgreSQL (connectPostgreSQL, Connection)

import Config (loadConfig, pgsqlOption)

connect :: IO Connection
connect = do
    pgsqlOption <$> loadConfig
    >>= connectPostgreSQL
