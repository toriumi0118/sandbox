{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.InformationRequestCount where

import Web.Scotty.Binding.Play (deriveBindable)

import Data.Text.Lazy (Text)

data InformationRequestCount = InformationRequestCount
    { businessKind :: Int
    , officeId :: Int
    , timestamp :: Text
    }
  deriving (Show)

deriveBindable ''InformationRequestCount
