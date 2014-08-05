{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.TopicCount where

import Web.Scotty.Binding.Play (deriveBindable)

data TopicCount = TopicCount
    { topicId :: Int
    , count :: Int
    , dateYmd :: Int
    }
  deriving (Show)

deriveBindable ''TopicCount
