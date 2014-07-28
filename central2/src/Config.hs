{-# LANGUAGE TemplateHaskell #-}

module Config
    ( Config(..)
    , loadConfig
    , pgsqlOption
    ) where

import Control.Exception (throwIO)
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Yaml as Yaml

data Config = Config
    { dbHost :: Maybe Text
    , dbPort :: Maybe Int
    , dbName :: Text
    , dbUser :: Maybe Text
    , dbPassword :: Maybe Text
    }
  deriving (Show)

$(deriveJSON defaultOptions ''Config)

loadConfig :: IO Config
loadConfig = do
    ea <- Yaml.decodeFileEither "./application.yml"
    case ea of
        Left err -> throwIO err
        Right a  -> return a

pgsqlOption :: Config -> String
pgsqlOption conf = intercalate " "
    [ f "dbname" T.unpack (Just $ dbName conf)
    , f "host" T.unpack (dbHost conf)
    , f "port" show (dbPort conf)
    , f "user" T.unpack (dbUser conf)
    , f "password" T.unpack (dbPassword conf)
    ]
  where
    f name g = maybe "" (\a -> intercalate "=" [name, g a])
