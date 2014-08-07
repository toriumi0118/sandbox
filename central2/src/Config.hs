{-# LANGUAGE TemplateHaskell #-}

module Config
    ( Config(..)
    , loadConfig
    ) where

import Control.Exception (throwIO)
import Data.Aeson.TH (deriveJSON, defaultOptions)
import qualified Data.Yaml as Yaml

data Config = Config
    { dbHost :: Maybe String
    , dbPort :: Maybe Int
    , dbSchema :: String
    , dbName :: Maybe String
    , dbUser :: Maybe String
    , dbPassword :: Maybe String
    }
  deriving (Show)

$(deriveJSON defaultOptions ''Config)

loadConfig :: IO Config
loadConfig = do
    ea <- Yaml.decodeFileEither "./application.yml"
    case ea of
        Left err -> throwIO err
        Right a  -> return a
