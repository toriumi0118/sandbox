{-# LANGUAGE FlexibleContexts, TemplateHaskell #-}

module Controller.Update
    ( UpdateData(..)
    , contents
    ) where

import Control.Applicative
import Control.Arrow (second)
import Control.Monad (when)
import Control.Monad.Error (catchError)
import Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Control.Monad.State as State
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.State (StateT)
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Aeson.TH (deriveJSON, defaultOptions, fieldLabelModifier)
import Data.Bifunctor (bimap)
import Data.Int (Int32, Int64)
import Data.List (partition)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe, isJust)
import Data.Monoid (mconcat)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty
import qualified Web.Scotty.Internal.Types as Scotty
import Web.Scotty.Binding.Play (parseParams)

import Auth (Auth)
import qualified Controller.Types.Class as C
import Controller.Types.UpdateReq (UpdateReq(..))
import Controller.Types.VersionupHisIds (VersionupHisIds(officeId))
import qualified Controller.Update.Kyotaku
import qualified Controller.Update.Office
import qualified Controller.Update.OfficeCase
import DataSource (Connection)
import qualified Query
import qualified Table.KyotakuHistory as KH
import qualified Table.OfficeAdHistory as OAH
import qualified Table.OfficeCaseHistory as OCH
import qualified Table.OfficeHistory as OH
import qualified Table.OfficePdf
import qualified Table.OfficeSpPriceHistory as OSPH
import Table.Types (TableName, PkColumn, Fields, TableContext)
import qualified Table.Types as T
import Util (clientError, initIf)

data UpdateResponseKey
    = DATA
    | DAT_INDEX
    | DAT_ACTION
    | DAT_TABLE
    | DAT_PK_COLUMN
    | DAT_DATA
    | FILES
    | OFFICE_KIND
    | OFFICE_ID
    | SERVICE_BUILDING_ID
    | FILE_NAME
    | FILE_URL
    | FILE_TYPE
    | FILE_ACtION
  deriving (Eq, Ord, Show)

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

deriveJSON defaultOptions{fieldLabelModifier = initIf (=='\'')} ''UpdateData

type History = (Int32, FileAction)

-- | from-toからoffice_idとactionのセットを取得するSQL
--   古い順にソート
history :: C.History a
    => Relation () a -- ^ テーブルのRelation
    -> Pi a Int64 -- ^ from toで指定するキー
    -> Relation (Int64, Int64) (Int32, String)
history historyRelation k = relation' $ do
    h <- query historyRelation
    (ph, ()) <- placeholder $ \range -> wheres $
        (h ! k .>. range ! fst') `and'`
        (h ! k .<. range ! snd')
    asc $ h ! C.id'
    return (ph, (h ! C.officeId' >< h ! C.action'))

-- | 指定したテーブルからfrom,toの間に更新されたエントリの
--   office_id,actionの組のリストを取得
targetHistories :: (MonadIO m, Functor m, FromSql SqlValue a, C.History a)
    => Connection
    -> Relation () a -- ^ テーブルSQL
    -> Pi a Int64 -- ^ from, toのキー
    -> VersionupHisIds -- ^ from
    -> VersionupHisIds -- ^ to
    -> m [History]
targetHistories conn r k from to = uniq . map (second read) <$>
    Query.runQuery conn (history r k) (curry (bimap oid oid) from to)
  where
    oid = fromIntegral . officeId
    uniq = Map.elems . flip State.execState Map.empty . uniq'
    uniq' []            = return ()
    uniq' (h@(i, _):hs) = State.modify (Map.insert i h) >> uniq' hs

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

toUpdateData :: ToJSON a
    => (a -> Int32)
    -> Fields
    -> TableName
    -> PkColumn
    -> (History, Maybe a)
    -> Maybe UpdateData
toUpdateData _ _      t pk ((i, DELETE), _      ) = deleteData t pk i
toUpdateData _ _      t pk ((i, UPDATE), Nothing) = deleteData t pk i
toUpdateData _ _      _ _  (_          , Nothing) = Nothing
toUpdateData k fields t pk ((_, act   ), Just o ) = Just
    $ UpdateData (fromIntegral $ k o) act t pk [toJSON fields, toJSON [o]]

deleteData :: String -> String -> Int32 -> Maybe UpdateData
deleteData tabName keyName oid = Just $ UpdateData
    oid'
    DELETE
    tabName
    keyName
    [toJSON [keyName], toJSON [oid']]
  where
    oid' :: Integer
    oid' = fromIntegral oid

updateDataTable :: (Functor m, MonadIO m)
    => Connection
    -> [History]
    -> TableContext
    -> m [Maybe UpdateData]
updateDataTable conn hs (T.TableContext rel k k' tab pk fields) = do
    let (del1, oth) = partition ((==) DELETE . snd) hs
    (del2, os) <- partition (isJust . snd) . classify k oth
        <$> Query.runQuery conn (inIdList rel k' $ map fst oth) ()
    let os' = os
            ++ map (\d -> (d, Nothing)) del1
            ++ map (\((i, _), _) -> ((i, DELETE), Nothing)) del2
    return $ map (toUpdateData k fields tab pk) os'

updateData :: (MonadIO m, Functor m)
    => Connection -> [TableContext] -> [History] -> m [Maybe UpdateData]
updateData conn ts hs = mconcat <$> sequence (map (updateDataTable conn hs) ts)

version :: ActionM (VersionupHisIds, VersionupHisIds)
version = do
    req <- parseParams "req"
    let from = androidDataIds req
        to   = serverDataIds req
    when (from == to) $ fail "already updated"
    return (from, to)

addData :: (MonadIO m, Functor m, C.History a, FromSql SqlValue a)
    => Connection
    -> Relation () a
    -> Pi a Int64
    -> [TableContext]
    -> VersionupHisIds
    -> VersionupHisIds
    -> StateT (Map String [Value]) m ()
addData conn rel hid tables from to =
    lift (targetHistories conn rel hid from to)
    >>= updateData conn tables
    >>= State.modify . f . toJSON
  where
    f = f' DATA
    f' k v m = Map.insert k' (v:fromMaybe [] (Map.lookup k' m)) m
      where
        k' = show k

contents :: Auth -> ActionM ()
contents _ = do
    (from, to) <- version
    Query.query (\conn -> flip State.execStateT Map.empty $ do
        addData conn OH.officeHistory OH.id'
            Controller.Update.Office.updateData from to
        addData conn KH.kyotakuHistory KH.id'
            Controller.Update.Kyotaku.updateData from to
        addData conn OAH.officeAdHistory OAH.id'
            [Table.OfficePdf.tableContext] from to
        addData conn OCH.officeCaseHistory OCH.id'
            Controller.Update.OfficeCase.updateData from to
        addData conn OSPH.officeSpPriceHistory OSPH.id'
            [Table.OfficePdf.tableContext] from to
        error "tmp"
      ) >>= Scotty.json
  `catchError` \e -> do
    liftIO $ print $ Scotty.showError e
    clientError
