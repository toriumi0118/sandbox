module Main where

import qualified Controller.Echo as Echo
import qualified Controller.PostPv as PostPv
import qualified Controller.VersionupResult as VersionupResult
import Network.Wai.Middleware.RequestLogger (logStdout)
import Web.Scotty

import Auth (auth)

main :: IO ()
main = scotty 3000 $ do
    middleware logStdout

    get "/echo/echo" Echo.echo

    auth post "/postpv/pv" PostPv.postPv

    auth post "/postresult/result" VersionupResult.result
    auth get "/postresult/results" VersionupResult.results
