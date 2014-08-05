{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.PvCount where

import Web.Scotty.Binding.Play (deriveBindable)

data PvCount = PvCount
    { pageType :: Int
    , officeId :: Int
    , count :: Int
    , dateYmd :: Int
    }
  deriving (Show)

deriveBindable ''PvCount
