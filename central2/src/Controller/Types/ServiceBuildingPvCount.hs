{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.ServiceBuildingPvCount where

import Web.Scotty.Binding.Play (deriveBindable)

data ServiceBuildingPvCount = ServiceBuildingPvCount
    { sbId :: Int
    , count :: Int
    , dateYmd :: Int
    , pageType :: Int
    }
  deriving (Show)

deriveBindable ''ServiceBuildingPvCount
