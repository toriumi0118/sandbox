{-# LANGUAGE FlexibleContexts, RankNTypes #-}

module Controller.Update
    ( contents
    ) where

import Control.Applicative
import Control.Monad (when)
import Control.Monad.Error (catchError)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader)
import qualified Control.Monad.Reader as Reader
import Control.Monad.State (MonadState)
import qualified Control.Monad.State as State
import Control.Monad.Trans.Class (lift, MonadTrans)
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Bifunctor (bimap)
import Data.Int (Int64)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import Database.HDBC (SqlValue)
import Database.Record (FromSql)
import Database.Relational.Query
import Web.Scotty (ActionM)
import qualified Web.Scotty as Scotty
import qualified Web.Scotty.Internal.Types as Scotty
import Web.Scotty.Binding.Play (parseParams)

import Auth (Auth(Auth))
import Controller.Types.UpdateReq (UpdateReq(..))
import Controller.Types.VersionupHisIds (VersionupHisIds)
import Controller.Update.DataProvider (DataProvider, runDataProvider, UpdateResponseKey(DATA, FILES), FileType(IMAGE, PRESENTATION, AD, CASE, SP_PRICE))
import Controller.Update.HistoryContext (HistoryContext(HistoryContext, hcPk, hcSelect), History)
import qualified Controller.Update.Kyotaku
import qualified Controller.Update.PdfDoc
import qualified Controller.Update.Office
import qualified Controller.Update.OfficeCase
import Controller.Update.UpdateData (updatedData)
import Controller.Update.UpdateFile (updatedFile)
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
import qualified Table.OfficeImageHistory as OIH
import qualified Table.OfficePdf
import qualified Table.OfficePresentationHistory as OPH
import qualified Table.OfficeSpPriceHistory as OSPH
import qualified Table.PdfDocHistory as PDH
import qualified Table.TopicHistory as TH
import qualified Table.Topic
import qualified Util

-- | from-toからtarget_idとactionのセットを取得するSQL
--   古い順にソート
history
    :: HistoryContext a
    -> Relation () a -- ^ テーブルのRelation
    -> Pi a Int64 -- ^ from toで指定するキー
    -> Relation (Int64, Int64) History
history hc historyRelation k = relation' $ do
    h <- query historyRelation
    (ph, ()) <- placeholder $ \range -> wheres $
        (h ! k .>. range ! fst') `and'`
        (h ! k .<. range ! snd')
    asc $ h ! hcPk hc
    return (ph, (hcSelect hc) h)

-- | 指定したテーブルからfrom,toの間に更新されたエントリの
--   target_id,actionの組のリストを取得
targetHistories :: (MonadIO m, Functor m, FromSql SqlValue a)
    => Connection
    -> HistoryContext a
    -> VersionupHisIds -- ^ from
    -> VersionupHisIds -- ^ to
    -> m [History]
targetHistories conn ctx@(HistoryContext r k' idk _) from to = Util.unique <$>
    Query.runQuery conn (history ctx r k') (curry (bimap oid oid) from to)
  where
    oid = fromIntegral . idk

version :: ActionM (VersionupHisIds, VersionupHisIds)
version = do
    req <- parseParams "req"
    let from = androidDataIds req
        to   = serverDataIds req
    when (from == to) $ fail "already updated"
    return (from, to)

addData
    :: (MonadIO m, Functor m, FromSql SqlValue a,
        MonadTrans t, MonadState (Map String [Value]) (t m),
        MonadReader (Connection, VersionupHisIds, VersionupHisIds) (t m))
    => UpdateResponseKey
    -> HistoryContext a
    -> DataProvider m ()
    -> t m ()
addData urkey ctx udata = do
    (conn, from, to) <- Reader.ask 
    hs <- lift $ targetHistories conn ctx from to
    lift (runDataProvider conn hs udata)
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
        addData DATA OAH.historyContext $ updatedData Table.OfficePdf.tableContext
        addData DATA OCH.historyContext Controller.Update.OfficeCase.updateData
        addData DATA OSPH.historyContext
            $ updatedData Table.OfficePdf.tableContext
        addData DATA NH.historyContext $ updatedData Table.NewsHead.tableContext
        addData DATA TH.historyContext
            $ updatedData $ Table.Topic.tableContext dev
        addData DATA PDH.historyContext Controller.Update.PdfDoc.updateData
        addData DATA CH.historyContext $ updatedData Table.Catalog.tableContext
        addData FILES OIH.historyContext $ updatedFile IMAGE
        addData FILES OPH.historyContext $ updatedFile PRESENTATION
        addData FILES OAH.historyContext $ updatedFile AD
        addData FILES OCH.historyContext $ updatedFile CASE
        addData FILES OSPH.historyContext $ updatedFile SP_PRICE
        error "tmp"
      ) >>= Scotty.json
  `catchError` \e -> do
    liftIO $ print $ Scotty.showError e
    Util.clientError
  where
    dev = if deviceId == -1 then Nothing else Just (fromIntegral deviceId)
