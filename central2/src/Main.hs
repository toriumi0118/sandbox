module Main where

import qualified Controller.Echo as Echo
import qualified Controller.VersionupResult as VersionupResult
import Web.Scotty

import Auth (auth)

main :: IO ()
main = scotty 3000 $ do
    get "/echo/echo" Echo.echo
    auth post "/postpv/pv" undefined
    auth post "/postresult/result" VersionupResult.result
    auth get "/postresult/results" VersionupResult.results
