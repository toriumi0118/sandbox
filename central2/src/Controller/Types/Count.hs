{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.Count where

import Controller.Types.Class

data Count = Count
    { pvcounts :: [Int] -- test
    }
  deriving (Show)

deriveBindable ''Count

data PvCount = PvCount
    {
    }
