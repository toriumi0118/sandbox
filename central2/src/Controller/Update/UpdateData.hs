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
import Data.Maybe (isJust)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import qualified Safe

import Controller.Update.DataProvider (DataProvider, getConnection, getHistories, store, History(History, hOfficeId, hAction), UpdateContent(UpdateData), FileAction(..))
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
    | hOfficeId h == k o = (h, Just o):classify k hs os
    | otherwise          = (h, Nothing):classify k hs (o:os)

deleteData :: (MonadIO m, Functor m)
    => Connection
    -> TableContext a
    -> Int32 -- ^ office id
    -> m (Maybe [UpdateContent])
deleteData conn ctx@(TableContext _ _ _ tabName keyName _ (NewsParam _ _)) oid = do
    (Just ds) <- deleteData conn ctx{param = NoParam} oid
    r1 <- f <$> Query.runQuery conn (Query.byKey NB.newsBody NB.id') (fromIntegral oid)
    r2 <- f <$> Query.runQuery conn (Query.byKey NOR.newsOfficeRel NOR.newsHeadId') (fromIntegral oid)
    return $ Just $ r2 ?: r1 ?: ds
  where
    f (a:_) = Just $
        UpdateData (fromIntegral oid) DELETE tabName keyName [toJSON a]
    f []    = Nothing
deleteData _ (TableContext _ _ _ tabName keyName _ _) oid =
    return $ Just $ (:[]) $ UpdateData
        oid'
        DELETE
        tabName
        keyName
        [toJSON [keyName], toJSON [oid']]
  where
    oid' :: Integer
    oid' = fromIntegral oid

toUpdateData :: (MonadIO m, Functor m, ToJSON a)
    => Connection
    -> TableContext a
    -> (History, Maybe a)
    -> m (Maybe [UpdateContent])
toUpdateData c ctx ((History i DELETE), _      ) = deleteData c ctx i
toUpdateData c ctx ((History i UPDATE), Nothing) = deleteData c ctx i
toUpdateData _ _   (_                 , Nothing) = return Nothing
toUpdateData _ (TableContext _ k _ t pk fs _) ((History _ act), Just o) =
    return $ Just $ (:[]) $ UpdateData
        (fromIntegral $ k o)
        act
        t
        pk
        [toJSON fs, toJSON [o]]

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
    hs <- getHistories
    let (del1, oth) = partition ((==) DELETE . hAction) hs
    conn <- getConnection
    (del2, os) <- lift $ partition (isJust . snd) . classify k oth <$> case mp of
        NewsParam p' p -> liftIO p >>=
            Query.runQuery conn (Query.inList p' k' $ map hOfficeId oth)
        TopicParam Nothing  _ ->
            Query.runQuery conn (Query.inList rel k' $ map hOfficeId oth) ()
        TopicParam (Just d) f -> do
            as <- Query.runQuery conn (Query.inList rel k' $ map hOfficeId oth) ()
            when (null as) $ fail "Topics are not exist."
            filterM (f conn $ pos K.latitude K.longitude <$> getKyotaku conn d) as
        NoParam ->
            Query.runQuery conn (Query.inList rel k' $ map hOfficeId oth) ()
    let os' = os
            ++ map (\d -> (d, Nothing)) del1
            ++ map (\((History i _), _) -> ((History i DELETE), Nothing)) del2
    lift (mapM (toUpdateData conn ctx) os') >>= store
