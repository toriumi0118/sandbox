module Auth
    ( Auth(..)
    , auth
    ) where

import Control.Applicative
import Control.Monad (when)
import Data.Text (Text)
import Web.Scotty

data Auth = Auth
    { deviceId :: Int
    }
  deriving (Show)

password :: Text
password = "we11motion"

auth :: (RoutePattern -> ActionM () -> ScottyM ())
    -> RoutePattern -> (Auth -> ActionM ()) -> ScottyM ()
auth m rt act = m rt $ do
    key <- param "key"
    when (key /= password) $ fail "auth failure"
    a <- Auth <$> param "deviceId"
    act a
