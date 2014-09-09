{-# LANGUAGE TemplateHaskell, FlexibleContexts, RankNTypes #-}

module Controller.Update.UpdateData
    where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO)
import Data.Aeson (ToJSON, toJSON, Value)
import Data.Aeson.TH (deriveJSON, defaultOptions, fieldLabelModifier)
import Data.Int (Int32)
import Data.List (partition)
import Data.Maybe (isJust)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query

import DataSource (Connection)
import qualified Query
import Util (initIf)

type TableName = String
type PkColumn = String
type Fields = [String]

data TableContext a = TableContext
    { tableRel :: Relation () a
    , officeId :: (a -> Int32)
    , officeId' :: Pi a Int32
    , tableName :: TableName
    , pkName :: PkColumn
    , fields :: Fields
    }

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

data DataProvider = NewsData | Default

deriveJSON defaultOptions{fieldLabelModifier = initIf (=='\'')} ''UpdateData

type UpdatedDataList = forall m. (MonadIO m, Functor m)
    => Connection -> [History] -> [m [Maybe [UpdateData]]]

inIdList :: (Integral i, Num j, ShowConstantTermsSQL j)
    => Relation () a -> Pi a j -> [i] -> Relation () a
inIdList rel k ids = relation $ do
    o <- query rel
    wheres $ o ! k `in'` values (map fromIntegral ids)
    asc $ o ! k
    return o

classify :: (a -> Int32) -> [History] -> [a]
    -> [(History, Maybe a)]
classify _ []     _      = []
classify k (h:hs) []     = (h, Nothing):classify k hs []
classify k (h:hs) (o:os)
    | fst h == k o       = (h, Just o):classify k hs os
    | otherwise          = (h, Nothing):classify k hs (o:os)

deleteData :: MonadIO m
    => DataProvider
    -> Connection
    -> TableContext a
    -> Int32 -- ^ office id
    -> m (Maybe [UpdateData])
deleteData NewsData _ _ _ = undefined
deleteData Default _ (TableContext _ _ _ tabName keyName _) oid = return $ Just $ (:[]) $ UpdateData
    oid'
    DELETE
    tabName
    keyName
    [toJSON [keyName], toJSON [oid']]
  where
    oid' :: Integer
    oid' = fromIntegral oid

toUpdateData :: (MonadIO m, ToJSON a)
    => DataProvider
    -> Connection
    -> TableContext a
    -> (History, Maybe a)
    -> m (Maybe [UpdateData])
toUpdateData dp c ctx ((i, DELETE), _      ) = deleteData dp c ctx i
toUpdateData dp c ctx ((i, UPDATE), Nothing) = deleteData dp c ctx i
toUpdateData _  _ _   (_          , Nothing) = return Nothing
toUpdateData _  _ (TableContext _ k _ t pk fs) ((_, act), Just o) =
    return $ Just $ (:[]) $ UpdateData
        (fromIntegral $ k o)
        act
        t
        pk
        [toJSON fs, toJSON [o]]

updatedData :: (Functor m, MonadIO m, FromSql SqlValue a, ToJSON a)
    => DataProvider
    -> Connection
    -> [History]
    -> TableContext a
    -> m [Maybe [UpdateData]]
updatedData dp conn hs ctx@(TableContext rel k k' _ _ _) = do
    let (del1, oth) = partition ((==) DELETE . snd) hs
    (del2, os) <- partition (isJust . snd) . classify k oth
        <$> Query.runQuery conn (inIdList rel k' $ map fst oth) ()
    let os' = os
            ++ map (\d -> (d, Nothing)) del1
            ++ map (\((i, _), _) -> ((i, DELETE), Nothing)) del2
    mapM (toUpdateData dp conn ctx) os'
