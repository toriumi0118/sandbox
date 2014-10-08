{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module DataSource.MySQL
    ( connect
    , driver
    ) where

import Control.Lens ((.=))
import qualified Control.Monad.State as State
import Data.Aeson (FromJSON(parseJSON), ToJSON(toJSON))
import Data.Time (LocalTime, ZonedTime(ZonedTime), getCurrentTimeZone)
import Database.HDBC (IConnection(..))
import Database.HDBC.MySQL (connectMySQL, defaultMySQLConnectInfo, MySQLConnectInfo)
import Database.HDBC.Schema.Driver (Driver)
import Database.HDBC.Schema.MySQL (driverMySQL)
import System.IO.Unsafe (unsafePerformIO)

import Config (Config(..))
import DataSource.Types (Connection(Connection))
import TH (makeLenses')
import Util (retry, fromJustM)

makeLenses' ''MySQLConnectInfo

connect :: Config -> IO Connection
connect config = fmap Connection $ retry 5 $ connectMySQL $
    flip State.execState defaultMySQLConnectInfo $ do
        mysqlDatabase .= dbSchema config
        fromJustM (mysqlHost .=) $ dbHost config
        fromJustM (mysqlUser .=) $ dbUser config
        fromJustM (mysqlPassword .=) $ dbPassword config
        fromJustM (mysqlPort .=) $ dbPort config
        fromJustM (mysqlUnixSocket .=) $ dbSocket config

driver :: IConnection conn => Driver conn
driver = driverMySQL

instance FromJSON LocalTime where
    parseJSON v = do
        (ZonedTime l _z) <- parseJSON v
        return l

instance ToJSON LocalTime where
    toJSON a = let z = unsafePerformIO getCurrentTimeZone
                     in toJSON $ ZonedTime a z
