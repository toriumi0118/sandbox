module Controller.Echo
    ( echo
    ) where

import Control.Applicative
import Data.Monoid (mconcat)
import qualified Data.Text.Lazy as T
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

echo :: ActionM ()
echo = mconcat . map f <$> Scotty.params >>= Scotty.html . T.tail
  where
    f (k, v) = mconcat ["&", k, "=", v]
