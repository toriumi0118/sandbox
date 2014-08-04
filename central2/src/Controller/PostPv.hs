{-# LANGUAGE TemplateHaskell #-}

module Controller.PostPv
    ( postPv
    ) where

import Database.HDBC.Record (runInsert)
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty

import Auth (Auth)
import qualified Auth
import Controller.Types.Class
import qualified Controller.Types.Count as Count
import qualified Controller.Types.PvCount as PvCount
import qualified Controller.Types.TopicCount as TopicCount
import DataSource (connect)
import qualified Query
import qualified Table.PvCountCollect as PV
import qualified Table.TopicPvCountCollect as TPV

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
        undefined
    Scotty.text "OK"
