{-# LANGUAGE ScopedTypeVariables #-}

module Util
    ( retry
    , fromJustM
    , clientError
    , initIf
    ) where

import Control.Exception (SomeException, catch)
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

retry :: Int -> IO a -> IO a
retry 0 io = io
retry n io = io `catch` \(_ :: SomeException) -> retry (n - 1) io

fromJustM :: Monad m => (a -> m ()) -> Maybe a -> m ()
fromJustM f = maybe (return ()) f

clientError :: ActionM ()
clientError = Scotty.text ""

initIf :: (a -> Bool) -> [a] -> [a]
initIf _ []       = []
initIf f [a]
    | f a         = []
    | otherwise   = [a]
initIf _ as@(_:_) = as
