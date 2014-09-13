{-# LANGUAGE TemplateHaskell, FlexibleContexts, RankNTypes #-}

module Controller.Update.UpdateData
    where

import Control.Applicative
import Control.Monad (when)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Aeson (ToJSON, toJSON, Value)
import Data.Aeson.TH (deriveJSON, defaultOptions, fieldLabelModifier)
import Data.Int (Int32)
import Data.List (partition)
import Data.Maybe (isJust)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)

import Controller.Update.TableContext (TableContext(..), TableName, PkColumn, TableContextParam(NoParam, NewsParam, TopicParam))
import DataSource (Connection)
import qualified Query
import qualified Table.NewsBody as NB
import qualified Table.NewsOfficeRel as NOR
import Util (initIf, cm)

data FileAction = INSERT | DELETE | UPDATE
  deriving (Show, Read, Eq)

deriveJSON defaultOptions ''FileAction

data UpdateData = UpdateData
    { index :: Integer
    , action :: FileAction
    , table :: TableName
    , pkColumn :: PkColumn
    , data' :: [Value]
    }

type History = (Int32, FileAction)

deriveJSON defaultOptions{fieldLabelModifier = initIf (=='\'')} ''UpdateData

type UpdatedDataList = forall m. (MonadIO m, Functor m)
    => Connection -> [History] -> [m [Maybe [UpdateData]]]

classify :: (a -> Int32) -> [History] -> [a]
    -> [(History, Maybe a)]
classify _ []     _      = []
classify k (h:hs) []     = (h, Nothing):classify k hs []
classify k (h:hs) (o:os)
    | fst h == k o       = (h, Just o):classify k hs os
    | otherwise          = (h, Nothing):classify k hs (o:os)

deleteData :: (MonadIO m, Functor m)
    => Connection
    -> TableContext a
    -> Int32 -- ^ office id
    -> m (Maybe [UpdateData])
deleteData conn ctx@(TableContext _ _ _ tabName keyName _ (NewsParam _ _)) oid = do
    (Just ds) <- deleteData conn ctx{param = NoParam} oid
    r1 <- f <$> Query.runQuery conn (Query.byKey NB.newsBody NB.id') (fromIntegral oid)
    r2 <- f <$> Query.runQuery conn (Query.byKey NOR.newsOfficeRel NOR.newsHeadId') (fromIntegral oid)
    return $ Just $ r2 `cm` r1 `cm` ds
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
    -> m (Maybe [UpdateData])
toUpdateData c ctx ((i, DELETE), _      ) = deleteData c ctx i
toUpdateData c ctx ((i, UPDATE), Nothing) = deleteData c ctx i
toUpdateData _ _   (_          , Nothing) = return Nothing
toUpdateData _ (TableContext _ k _ t pk fs _) ((_, act), Just o) =
    return $ Just $ (:[]) $ UpdateData
        (fromIntegral $ k o)
        act
        t
        pk
        [toJSON fs, toJSON [o]]

updatedData :: (Functor m, MonadIO m, FromSql SqlValue a, ToJSON a)
    => Connection
    -> [History]
    -> TableContext a
    -> m [Maybe [UpdateData]]
updatedData conn hs ctx@(TableContext rel k k' _ _ _ mp) = do
    let (del1, oth) = partition ((==) DELETE . snd) hs
    (del2, os) <- partition (isJust . snd) . classify k oth
        <$> case mp of
            NewsParam p' p     -> liftIO p >>=
                Query.runQuery conn (Query.inList p' k' $ map fst oth)
            TopicParam True    ->
                Query.runQuery conn (Query.inList rel k' $ map fst oth) ()
            TopicParam False   -> do
                as <- Query.runQuery conn (Query.inList rel k' $ map fst oth) ()
                when (null as) $ fail "Topics are not exist."
                undefined
            NoParam            ->
                Query.runQuery conn (Query.inList rel k' $ map fst oth) ()
    let os' = os
            ++ map (\d -> (d, Nothing)) del1
            ++ map (\((i, _), _) -> ((i, DELETE), Nothing)) del2
    mapM (toUpdateData conn ctx) os'
