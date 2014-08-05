{-# LANGUAGE TemplateHaskell, FlexibleInstances #-}

module Controller.Types.PostResult where

import Web.Scotty.Binding.Play (deriveBindable)

import Data.Text.Lazy (Text)

data PostResult = PostResult
    { succeed :: Bool
    , message :: Text
    }

deriveBindable ''PostResult
