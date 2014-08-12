{-# LANGUAGE TemplateHaskell #-}

module Controller.PostPv
    ( postPv
    ) where

import Data.Text.Lazy (Text, toStrict)
import Data.Text.Encoding (encodeUtf8)
import qualified Data.UnixTime as Time
import Database.HDBC.Record (runInsert)
import Foreign.C.Types (CTime(CTime))
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty
import Web.Scotty.Binding.Play (parseParams)

import Auth (Auth)
import qualified Auth
import qualified Controller.Types.Count as Count
import qualified Controller.Types.PvCount as PvCount
import qualified Controller.Types.TopicCount as TopicCount
import qualified Controller.Types.ServiceBuildingPvCount as SbPvCount
import qualified Controller.Types.InformationRequestCount as ReqCount
import DataSource (connect)
import qualified Query
import qualified Table.PvCountCollect as PV
import qualified Table.TopicPvCountCollect as TPV
import qualified Table.ServiceBuildingCountCollect as SPV
import qualified Table.RequestInformation as RI

postPv :: Auth -> ActionM ()
postPv auth = do
    pv <- parseParams "data"
    Query.execUpdate connect $ \conn -> do
        mapM (\opv -> runInsert conn PV.insertPvCountCollect
            $ PV.PvCountCollect
                (fromIntegral $ PvCount.pageType opv)
                (fromIntegral $ PvCount.officeId opv)
                (fromIntegral $ PvCount.dateYmd opv)
                (fromIntegral $ Auth.deviceId auth)
                (fromIntegral $ PvCount.count opv)
            ) $ Count.pvcounts pv
        mapM (\tpv -> runInsert conn TPV.insertTopicPvCountCollect
            $ TPV.TopicPvCountCollect
                (fromIntegral $ TopicCount.topicId tpv)
                (fromIntegral $ TopicCount.dateYmd tpv)
                (fromIntegral $ TopicCount.count tpv)
                (fromIntegral $ Auth.deviceId auth)
            ) $ Count.topicpvcounts pv
        mapM (\sbpv -> runInsert conn SPV.insertServiceBuildingCountCollect
            $ SPV.ServiceBuildingCountCollect
                (fromIntegral $ SbPvCount.sbId sbpv)
                (fromIntegral $ SbPvCount.dateYmd sbpv)
                (fromIntegral $ Auth.deviceId auth)
                (fromIntegral $ SbPvCount.count sbpv)
                (fromIntegral $ SbPvCount.pageType sbpv)
            ) $ Count.sbpvcounts pv
        mapM (\ri -> runInsert conn RI.insertRequestInformation
            $ RI.RequestInformation
                (fromIntegral $ ReqCount.businessKind ri)
                (fromIntegral $ ReqCount.officeId ri)
                (parseTime $ ReqCount.timestamp ri)
                (fromIntegral $ Auth.deviceId auth)
            ) $ Count.inforequestcounts pv
    Scotty.text "OK"

parseTime :: Integral int => Text -> int
parseTime
    = fromIntegral
    . (* 1000)
    . (\(CTime i) -> i)
    . Time.utSeconds
    . Time.parseUnixTime fmt
    . encodeUtf8
    . toStrict
  where
    fmt = "%Y-%m-%dT%H:%M:%S"
