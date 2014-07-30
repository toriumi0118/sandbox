{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.PostResult where

import Data.Text.Lazy (Text)

import Controller.Types.Class

data PostResult = PostResult
    { succeed :: Bool
    , message :: Text
    }

deriveParam ''PostResult
