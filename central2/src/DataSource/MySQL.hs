{-# OPTIONS_GHC -fno-warn-orphans #-}

module DataSource.MySQL
    ( connect
    , driver
    ) where

import qualified Control.Monad.State as State
import Data.Aeson (FromJSON(parseJSON), ToJSON(toJSON))
import Data.Time (LocalTime, ZonedTime(ZonedTime), getCurrentTimeZone)
import Database.HDBC (IConnection(..))
import Database.HDBC.MySQL (connectMySQL, defaultMySQLConnectInfo, MySQLConnectInfo(..))
import Database.HDBC.Schema.Driver (Driver)
import Database.HDBC.Schema.MySQL (driverMySQL)
import System.IO.Unsafe (unsafePerformIO)

import Config (Config(..))
import DataSource.Types (Connection(Connection))
import Util (retry, fromJustM)

connect :: Config -> IO Connection
connect config = fmap Connection $ retry 5 $ connectMySQL $
    flip State.execState defaultMySQLConnectInfo $ do
        State.modify $ \i -> i { mysqlDatabase = dbSchema config }
        fromJustM (\h -> State.modify $ \i -> i { mysqlHost = h }) $ dbHost config
        fromJustM (\u -> State.modify $ \i -> i { mysqlUser = u }) $ dbUser config
        fromJustM (\p -> State.modify $ \i -> i { mysqlPassword = p }) $ dbPassword config
        fromJustM (\p -> State.modify $ \i -> i { mysqlPort = p }) $ dbPort config

driver :: IConnection conn => Driver conn
driver = driverMySQL

instance FromJSON LocalTime where
    parseJSON v = do
        (ZonedTime l _z) <- parseJSON v
        return l

instance ToJSON LocalTime where
    toJSON a = let z = unsafePerformIO getCurrentTimeZone
                     in toJSON $ ZonedTime a z
