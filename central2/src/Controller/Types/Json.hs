{-# OPTIONS_GHC -fno-warn-orphans #-}

module Controller.Types.Json where

import Data.Aeson (FromJSON(..), ToJSON(..))
import Data.Time (NominalDiffTime, UTCTime(..), Day(..), addUTCTime)

instance FromJSON NominalDiffTime where
    parseJSON = undefined

instance ToJSON NominalDiffTime where
    toJSON = toJSON . flip addUTCTime (UTCTime (ModifiedJulianDay 0) 0)
