{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.InformationRequestCount where

import Data.Text.Lazy (Text)
import Controller.Types.Class

data InformationRequestCount = InformationRequestCount
    { businessKind :: Int
    , officeId :: Int
    , timestamp :: Text
    }
  deriving (Show)

deriveBindable ''InformationRequestCount
