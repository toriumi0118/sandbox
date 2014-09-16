{-# LANGUAGE FlexibleContexts, TemplateHaskell #-}

module Controller.Update
    ( UpdateData
    , contents
    ) where

import Control.Applicative
import Control.Arrow (second)
import Control.Monad (when)
import Control.Monad.Error (catchError)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, ReaderT)
import qualified Control.Monad.Reader as Reader
import Control.Monad.State (MonadState)
import qualified Control.Monad.State as State
import Control.Monad.Trans.Class (lift, MonadTrans)
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Bifunctor (bimap)
import Data.Int (Int32, Int64)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import Data.Monoid (mconcat)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty
import qualified Web.Scotty.Internal.Types as Scotty
import Web.Scotty.Binding.Play (parseParams)

import Auth (Auth(Auth))
import qualified Controller.Types.Class as C
import Controller.Types.UpdateReq (UpdateReq(..))
import Controller.Types.VersionupHisIds (VersionupHisIds)
import Controller.Update.HistoryContext (HistoryContext(HistoryContext))
import qualified Controller.Update.Kyotaku
import qualified Controller.Update.PdfDoc
import qualified Controller.Update.Office
import qualified Controller.Update.OfficeCase
import Controller.Update.UpdateData (updatedData, History, UpdateData)
import DataSource (Connection)
import qualified Query
import qualified Table.Catalog
import qualified Table.CatalogHistory as CH
import qualified Table.KyotakuHistory as KH
import qualified Table.NewsHistory as NH
import qualified Table.NewsHead
import qualified Table.OfficeAdHistory as OAH
import qualified Table.OfficeCaseHistory as OCH
import qualified Table.OfficeHistory as OH
--import qualified Table.OfficeImageHistory as OIH
import qualified Table.OfficePdf
import qualified Table.OfficeSpPriceHistory as OSPH
import qualified Table.PdfDocHistory as PDH
import qualified Table.TopicHistory as TH
import qualified Table.Topic
import Util (clientError)

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
    -> HistoryContext a
    -> VersionupHisIds -- ^ from
    -> VersionupHisIds -- ^ to
    -> m [History]
targetHistories conn (HistoryContext r k' idk) from to =
    uniq . map (second read) <$>
        Query.runQuery conn (history r k') (curry (bimap oid oid) from to)
  where
    oid = fromIntegral . idk
    uniq = Map.elems . flip State.execState Map.empty . uniq'
    uniq' []            = return ()
    uniq' (h@(i, _):hs) = State.modify (Map.insert i h) >> uniq' hs

version :: ActionM (VersionupHisIds, VersionupHisIds)
version = do
    req <- parseParams "req"
    let from = androidDataIds req
        to   = serverDataIds req
    when (from == to) $ fail "already updated"
    return (from, to)

addData
    :: (MonadIO m, Functor m, C.History a, FromSql SqlValue a,
        MonadTrans t, MonadState (Map String [Value]) (t m),
        MonadReader (Connection, VersionupHisIds, VersionupHisIds) (t m))
    => UpdateResponseKey
    -> HistoryContext a
    -> [ReaderT (Connection, [History]) m [Maybe [UpdateData]]]
    -> t m ()
addData urkey ctx udata = do
    (conn, from, to) <- Reader.ask 
    hs <- lift $ targetHistories conn ctx from to
    lift (mconcat <$> Reader.runReaderT (sequence udata) (conn, hs))
        >>= State.modify . f . toJSON
  where
    f = f' urkey
    f' k v m = Map.insert k' (v:fromMaybe [] (Map.lookup k' m)) m
      where
        k' = show k

contents :: Auth -> ActionM ()
contents (Auth deviceId) = do
    (from, to) <- version
    Query.query (\conn -> flip State.execStateT Map.empty $
            flip Reader.runReaderT (conn, from, to) $ do
        addData DATA OH.historyContext Controller.Update.Office.updateData
        addData DATA KH.historyContext Controller.Update.Kyotaku.updateData
        addData DATA OAH.historyContext [updatedData Table.OfficePdf.tableContext]
        addData DATA OCH.historyContext Controller.Update.OfficeCase.updateData
        addData DATA OSPH.historyContext
            [updatedData Table.OfficePdf.tableContext]
        addData DATA NH.historyContext [updatedData Table.NewsHead.tableContext]
        addData DATA TH.historyContext
            [updatedData $ Table.Topic.tableContext dev]
        addData DATA PDH.historyContext Controller.Update.PdfDoc.updateData
        addData DATA CH.historyContext [updatedData Table.Catalog.tableContext]
--        addData FILES OIH.historyContext [updatedData undefined]
        error "tmp"
      ) >>= Scotty.json
  `catchError` \e -> do
    liftIO $ print $ Scotty.showError e
    clientError
  where
    dev = if deviceId == -1 then Nothing else Just (fromIntegral deviceId)
