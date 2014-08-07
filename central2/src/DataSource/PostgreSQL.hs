module DataSource.PostgreSQL
    ( connect
    , driver
    ) where

import Data.List (intercalate)
import Database.HDBC.PostgreSQL (connectPostgreSQL, Connection)
import Database.HDBC.Schema.Driver (Driver)
import Database.HDBC.Schema.PostgreSQL (driverPostgreSQL)

import Config (Config(..))

connect :: Config -> IO Connection
connect = connectPostgreSQL . pgsqlOption

driver :: Driver Connection
driver = driverPostgreSQL

pgsqlOption :: Config -> String
pgsqlOption conf = intercalate " "
    [ f "dbname" id (dbName conf)
    , f "host" id (dbHost conf)
    , f "port" show (dbPort conf)
    , f "user" id (dbUser conf)
    , f "password" id (dbPassword conf)
    ]
  where
    f name g = maybe "" (\a -> intercalate "=" [name, g a])
