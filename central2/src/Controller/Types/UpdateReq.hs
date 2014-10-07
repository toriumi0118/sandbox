{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.UpdateReq where

import Web.Scotty.Binding.Play (deriveBindable)

import Controller.Types.VersionupHisIds (VersionupHisIds)

data UpdateReq = UpdateReq
    { androidDataIds :: VersionupHisIds
    , serverDataIds :: VersionupHisIds
    }

deriveBindable ''UpdateReq
