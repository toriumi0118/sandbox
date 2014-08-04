{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.PvCount where

import Controller.Types.Class

data PvCount = PvCount
    { pageType :: Int
    , officeId :: Int
    , count :: Int
    , dateYmd :: Int
    }
  deriving (Show)

deriveBindable ''PvCount
