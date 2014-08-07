module DataSource
    ( connect
    , defineTable
    ) where

import Data.List (intercalate)
import Database.HDBC.PostgreSQL (connectPostgreSQL, Connection)
import Database.HDBC.Query.TH (defineTableFromDB)
import Database.HDBC.Schema.PostgreSQL (driverPostgreSQL)
import Database.Record.TH (derivingShow)
import Language.Haskell.TH

import Config (loadConfig, Config(..))

connect :: IO Connection
connect = loadConfig >>= connect'

connect' :: Config -> IO Connection
connect' = connectPostgreSQL . pgsqlOption

defineTable :: String -> DecsQ
defineTable table = do
    c <- runIO loadConfig
    defineTableFromDB
        (connect' c)
        driverPostgreSQL
        (dbSchema c)
        table
        [derivingShow]

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
