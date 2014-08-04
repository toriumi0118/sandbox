{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.Count where

import Controller.Types.Class
import Controller.Types.TopicCount
import Controller.Types.PvCount
import Controller.Types.ServiceBuildingPvCount
import Controller.Types.InformationRequestCount

data Count = Count
    { pvcounts :: [PvCount]
    , topicpvcounts :: [TopicCount]
    , sbpvcounts :: [ServiceBuildingPvCount]
    , inforequestcounts :: [InformationRequestCount]
    , postYmd :: Int
    }
  deriving (Show)

deriveBindable ''Count
