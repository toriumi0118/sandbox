{-# LANGUAGE TemplateHaskell #-}

module Controller.VersionupResult
    ( result
    , results
    ) where

import Control.Applicative
import Control.Monad.IO.Class (liftIO)
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Data.Monoid
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as LT
import Data.Time.LocalTime (ZonedTime)
import qualified Data.Time.LocalTime as Time
import Database.HDBC.Record (runInsert)
import Database.Relational.Query
import GHC.Int (Int32)
import Prelude hiding (id)
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

import Auth (Auth)
import qualified Auth
import DataSource (connect)
import qualified Query
import Table.UpdateResult (UpdateResult)
import qualified Table.UpdateResult as UR
import Table.Device (Device)
import qualified Table.Device as D

data ResultsJson = ResultsJson
    { id :: !Int32
    , message :: !(Maybe String)
    , prcDate :: !ZonedTime
    , succeed :: !Int32
    , device :: !Device
    }

$(deriveJSON defaultOptions ''ResultsJson)

data PostResult = PostResult
    { succeed' :: Bool
    , message' :: Text
    }

parseParams :: Text -> ActionM (Maybe PostResult)
parseParams name = do
    s <- Scotty.param $ mconcat [name, ".", "succeed"]
    m <- Scotty.param $ mconcat [name, ".", "message"]
    return $ Just $ PostResult s m

result :: Auth -> ActionM ()
result a = do
    mpr <- parseParams "data"
    case mpr of
        Nothing -> fail "no data"
        Just pr -> do
            now <- liftIO $ Time.getZonedTime
            Query.execUpdate connect $ \conn -> do
                runInsert conn UR.insertUpdateResult'
                    ( ( ( Just $ LT.unpack $ message' pr
                        , now)
                      , if succeed' pr then 1 else 0)
                    , fromIntegral $ Auth.deviceId a)
            Scotty.text "OK"

resultsQuery :: Relation () (UpdateResult, Device)
resultsQuery = relation $ do
    r <- query UR.updateResult
    d <- query D.device
    on $ r ! UR.deviceId' .=. d ! D.id'
    return $ r >< d

results :: Auth -> ActionM ()
results _ = do
    Query.execQuery connect $ \conn ->
        map pack <$> Query.runQuery conn resultsQuery ()
    >>= Scotty.json
  where
    pack (r, d) = ResultsJson
        { id = UR.id r
        , message = UR.message r
        , prcDate = UR.prcDate r
        , succeed = UR.succeed r
        , device = d
        }
