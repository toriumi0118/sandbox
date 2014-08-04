{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.TopicCount where

import Controller.Types.Class

data TopicCount = TopicCount
    { topicId :: Int
    , count :: Int
    , dateYmd :: Int
    }
  deriving (Show)

deriveBindable ''TopicCount
