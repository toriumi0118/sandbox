{-# LANGUAGE TemplateHaskell #-}

module Controller.PostPv
    ( postPv
    ) where

import Control.Monad.IO.Class
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

import Auth (Auth)
import Controller.Types.Class
import Controller.Types.Count

postPv :: Auth -> ActionM ()
postPv _ = do
    undefined
