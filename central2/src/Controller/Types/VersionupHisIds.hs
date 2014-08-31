{-# LANGUAGE TemplateHaskell #-}

module Controller.Types.VersionupHisIds where

import Web.Scotty.Binding.Play (deriveBindable)

data VersionupHisIds = VersionupHisIds
    { officeId :: Integer
    , kyotakuId :: Integer
    , newsHeadId :: Integer
    , topicId :: Integer
    , officeImageId :: Integer
    , officePresentationId :: Integer
    , officeAdId :: Integer
    , officeCaseId :: Integer
    , officeSpPriceId :: Integer
    , pdfDocId :: Integer
    , catalogId :: Integer
    , serviceBuildingId :: Integer
    , serviceBuildingImgId :: Integer
    , serviceBuildingRoomTypeImgId :: Integer
    , serviceBuildingPresentationId :: Integer
    , sbAdId :: Integer
    , relatedOfficeId :: Integer
    }
  deriving (Eq)

deriveBindable ''VersionupHisIds
