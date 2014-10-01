{-# LANGUAGE ScopedTypeVariables #-}

module Util
    ( retry
    , fromJustM
    , clientError
    , unique
    , (?:)
    , replaceSuffix
    ) where

import Control.Applicative
import Control.Exception (SomeException, catch)
import qualified Data.Set as Set
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

retry :: Int -> IO a -> IO a
retry 0 io = io
retry n io = io `catch` \(_ :: SomeException) -> retry (n - 1) io

fromJustM :: Monad m => (a -> m ()) -> Maybe a -> m ()
fromJustM f = maybe (return ()) f

clientError :: ActionM ()
clientError = Scotty.text ""

unique :: Ord a => [a] -> [a]
unique = Set.toList . Set.fromList

(?:) :: Maybe a -> [a] -> [a]
Nothing ?: xs = xs
Just x  ?: xs = x:xs

infixr 7 ?:

replaceSuffix :: String -> String -> String -> Maybe String
replaceSuffix pat rep str = (++ rep) <$> stripSuffix pat str

stripSuffix :: String -> String -> Maybe String
stripSuffix pat str = reverse <$> stripPrefix (reverse pat) (reverse str)

stripPrefix :: String -> String -> Maybe String
stripPrefix []    cs = Just cs
stripPrefix (_:_) [] = Nothing
stripPrefix (p:ps) (c:cs)
    | p == c    = stripPrefix ps cs
    | otherwise = Nothing
