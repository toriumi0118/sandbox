{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.Count where

import Controller.Types.Class

data Count = Count
    { pvcounts :: [Int] -- test
    }
  deriving (Show)

deriveParam ''Count

data PvCount = PvCount
    {
    }
