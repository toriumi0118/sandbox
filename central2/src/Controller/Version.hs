{-# LANGUAGE FlexibleContexts #-}

module Controller.Version
    ( versionupInfo
    ) where

import Control.Applicative
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.State (StateT)
import qualified Control.Monad.Trans.State as State
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Int (Int64)
import Data.Map (Map)
import qualified Data.Map as Map
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query
import Safe (headMay)
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

import Auth (Auth)
import DataSource (Connection)
import qualified Query
import qualified Table.OfficeHistory as OH
import qualified Table.KyotakuHistory as KH
import qualified Table.NewsHistory as NH
import qualified Table.TopicHistory as TH
import qualified Table.OfficeImageHistory as OIH
import qualified Table.OfficePresentationHistory as OPH
import qualified Table.OfficeAdHistory as OAH
import qualified Table.OfficeCaseHistory as OCH
import qualified Table.OfficeSpPriceHistory as OSPH
import qualified Table.PdfDocHistory as PDH
import qualified Table.CatalogHistory as CH
import qualified Table.ServiceBuildingHistory as SBH
import qualified Table.ServiceBuildingImageHistory as SBIH
import qualified Table.ServiceBuildingRoomTypeImgHistory as SBRTIH
import qualified Table.ServiceBuildingPresentationHistory as SBPH
import qualified Table.SbAdHistory as SAH
import qualified Table.RelatedOfficeHistory as ROH
import qualified Table.Version as Version
import Util (fromJustM)

versionOrd :: Relation () Version.Version
versionOrd = relation $ do
    v <- query Version.version
    asc $ v ! Version.prcDate'
    return v

recent :: Relation () a -> Pi a Int64 -> Relation () a
recent r k = relation $ do
    h <- query r
    desc $ h ! k
    return h

recentHis :: (FromSql SqlValue a)
    => Connection -> Relation () a -> Pi a Int64 -> IO (Maybe a)
recentHis conn rel k =
    headMay <$> Query.runQuery conn (recent rel k) ()

insertIfNotNull :: ToJSON a
    => String -> Maybe a -> StateT (Map String Value) IO ()
insertIfNotNull name = fromJustM $ State.modify . Map.insert name . toJSON

storeRecentHis :: (FromSql SqlValue a, ToJSON a)
    => Connection -> String -> Relation () a -> Pi a Int64
    -> StateT (Map String Value) IO ()
storeRecentHis conn name rel k = do
    his <- lift $ recentHis conn rel k
    insertIfNotNull name his

getHisIds :: Connection -> IO (Map String Value)
getHisIds conn = flip State.execStateT Map.empty $ do
    storeRecentHis conn "officeId" OH.officeHistory OH.id'
    storeRecentHis conn "kyotakuId" KH.kyotakuHistory KH.id'
    storeRecentHis conn "newsHeadId" NH.newsHistory NH.id'
    storeRecentHis conn "topicId" TH.topicHistory TH.id'
    storeRecentHis conn "officeImageId" OIH.officeImageHistory OIH.id'
    storeRecentHis conn "officePresentationId" OPH.officePresentationHistory OPH.id'
    storeRecentHis conn "officeAdId" OAH.officeAdHistory OAH.id'
    storeRecentHis conn "officeCaseId" OCH.officeCaseHistory OCH.id'
    storeRecentHis conn "officeSpPriceId" OSPH.officeSpPriceHistory OSPH.id'
    storeRecentHis conn "pdfDocId" PDH.pdfDocHistory PDH.id'
    storeRecentHis conn "catalogId" CH.catalogHistory CH.id'
    storeRecentHis conn "serviceBuildingId" SBH.serviceBuildingHistory SBH.id'
    storeRecentHis conn "serviceBuildingImgId" SBIH.serviceBuildingImageHistory SBIH.id'
    storeRecentHis conn "serviceBuildingRoomTypeImgId" SBRTIH.serviceBuildingRoomTypeImgHistory SBRTIH.id'
    storeRecentHis conn "serviceBuildingPresentationId" SBPH.serviceBuildingPresentationHistory SBPH.id'
    storeRecentHis conn "sbAdId" SAH.sbAdHistory SAH.id'
    storeRecentHis conn "relatedOfficeId" ROH.relatedOfficeHistory ROH.id'

versionupInfo :: Auth -> ActionM ()
versionupInfo _ = do
    (vs, hs) <- Query.query $ \conn -> (,)
        <$> Query.runQuery conn versionOrd ()
        <*> getHisIds conn
    let r = Map.fromList
            [ (versionsKey, toJSON vs)
            , ("dataHisIds", toJSON hs)
            ]
    Scotty.json r
  where
    versionsKey :: String
    versionsKey = "versions"
