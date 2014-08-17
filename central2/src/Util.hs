{-# LANGUAGE ScopedTypeVariables #-}

module Util
    ( retry
    , fromJustM
    ) where

import Control.Exception (SomeException, catch)

retry :: Int -> IO a -> IO a
retry 0 io = io
retry n io = io `catch` \(_ :: SomeException) -> retry (n - 1) io

fromJustM :: Monad m => (a -> m ()) -> Maybe a -> m ()
fromJustM f = maybe (return ()) f
