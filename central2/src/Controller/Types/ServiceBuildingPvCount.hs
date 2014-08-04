{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.ServiceBuildingPvCount where

import Controller.Types.Class

data ServiceBuildingPvCount = ServiceBuildingPvCount
    { sbId :: Int
    , count :: Int
    , dateYmd :: Int
    }
  deriving (Show)

deriveBindable ''ServiceBuildingPvCount
