module DataSource
    ( connect
    , defineTable
    , Connection
    ) where

import Database.HDBC.Query.TH (defineTableFromDB)
import Database.Record.TH (derivingShow)
import Language.Haskell.TH

import Config (loadConfig, Config(..))
import qualified DataSource.MySQL as MySQL
import DataSource.Types (Connection)

connect :: IO Connection
connect = loadConfig >>= MySQL.connect

defineTable :: String -> DecsQ
defineTable table = do
    c <- runIO loadConfig
    defineTableFromDB
        (MySQL.connect c)
        MySQL.driver
        (dbSchema c)
        table
        [derivingShow]
