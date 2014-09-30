{-# LANGUAGE TemplateHaskell, FlexibleContexts, RankNTypes, GeneralizedNewtypeDeriving #-}

module Controller.Update.UpdateData
    ( updatedData
    ) where

import Control.Applicative
import Control.Monad (when, filterM, join)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Trans.Class (lift)
import Data.Aeson (ToJSON, toJSON)
import Data.Int (Int32)
import Data.List (partition)
import Data.Maybe (isJust, fromJust, isNothing)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import qualified Safe

import Controller.Update.DataProvider (DataProvider, getConnection, getHistories, store, UpdateContent(UpdateData), HistoryId)
import Controller.Update.HistoryContext (History(History, FileHistory, DirHistory), FileAction(DELETE, UPDATE), order, targetId, action)
import Controller.Update.TableContext (TableContext(..), TableContextParam(NoParam, NewsParam, TopicParam), pos)
import DataSource (Connection)
import qualified Query
import qualified Table.Device as D
import qualified Table.Kyotaku as K
import qualified Table.NewsBody as NB
import qualified Table.NewsOfficeRel as NOR
import Util ((?:))

classify :: (a -> Int32) -> [History] -> [a]
    -> [(History, Maybe a)]
classify _ []     _      = []
classify k (h:hs) []     = (h, Nothing):classify k hs []
classify k (h:hs) (o:os)
    | targetId h == k o = (h, Just o):classify k hs os
    | otherwise          = (h, Nothing):classify k hs (o:os)

deleteData :: (MonadIO m, Functor m)
    => Connection
    -> TableContext a
    -> HistoryId
    -> Int32 -- ^ office id
    -> m [(HistoryId, UpdateContent)]
deleteData conn ctx@(TableContext _ _ _ tabName keyName _ (NewsParam _ _)) hid oid = do
    ds <- deleteData conn ctx{param = NoParam} hid oid
    r1 <- f <$> Query.runQuery conn (Query.byKey NB.newsBody NB.id') (fromIntegral oid)
    r2 <- f <$> Query.runQuery conn (Query.byKey NOR.newsOfficeRel NOR.newsHeadId') (fromIntegral oid)
    return $ fmap w r2 ?: fmap w r1 ?: ds
  where
    f (a:_) = Just $
        UpdateData (fromIntegral oid) DELETE tabName keyName [toJSON a]
    f []    = Nothing
    w = (,) hid
deleteData _ (TableContext _ _ _ tabName keyName _ _) hid oid =
    return [(hid, UpdateData
        oid'
        DELETE
        tabName
        keyName
        [toJSON [keyName], toJSON [oid']]
        )]
  where
    oid' :: Integer
    oid' = fromIntegral oid

toUpdateData :: (MonadIO m, Functor m, ToJSON a)
    => Connection
    -> TableContext a
    -> (History, Maybe a)
    -> m [(HistoryId, UpdateContent)]
toUpdateData c ctx@(TableContext _ k _ t pk fs _) (h, mo)
    | action h == DELETE              = deleteData c ctx (order h) (targetId h)
    | action h == UPDATE && isJust mo = deleteData c ctx (order h) (targetId h)
    | isNothing mo                    = return []
    | otherwise                       = return [(order h, UpdateData
        (fromIntegral $ k $ fromJust mo)
        (action h)
        t
        pk
        [toJSON fs, toJSON [fromJust mo]]
        )]

type DeviceId = Int32

getKyotaku :: (MonadIO m, Functor m)
    => Connection -> DeviceId -> m (Maybe K.Kyotaku)
getKyotaku conn devId =
    Safe.headMay
        <$> Query.runQuery conn (Query.byKey D.device D.id') devId
    >>= maybe
        (return Nothing)
        (fmap Safe.headMay
            . Query.runQuery conn (Query.byKey K.kyotaku K.officeId'))
      . fmap fromIntegral
      . join
      . fmap D.kyotakuId

updatedData :: (Functor m, MonadIO m, FromSql SqlValue a, ToJSON a)
    => TableContext a -> DataProvider m ()
updatedData ctx@(TableContext rel k k' _ _ _ mp) = do
    hs <- map convHis <$> getHistories
    let (del1, oth) = partition ((==) DELETE . action) hs
    conn <- getConnection
    (del2, os) <- lift $ partition (isJust . snd) . classify k oth <$> case mp of
        NewsParam p' p -> liftIO p >>=
            Query.runQuery conn (Query.inList p' k' $ map targetId oth)
        TopicParam Nothing  _ ->
            Query.runQuery conn (Query.inList rel k' $ map targetId oth) ()
        TopicParam (Just d) f -> do
            as <- Query.runQuery conn (Query.inList rel k' $ map targetId oth) ()
            when (null as) $ fail "Topics are not exist."
            filterM (f conn $ pos K.latitude K.longitude <$> getKyotaku conn d) as
        NoParam ->
            Query.runQuery conn (Query.inList rel k' $ map targetId oth) ()
    let os' = os
            ++ map (\d -> (d, Nothing)) del1
            ++ map (\((History o i _), _) -> ((History o i DELETE), Nothing)) del2
    lift (concat <$> mapM (toUpdateData conn ctx) os') >>= store
  where
    convHis (FileHistory i t a _) = History i t a
    convHis (DirHistory i t a _) = History i t a
    convHis h@(History _ _ _) = h
