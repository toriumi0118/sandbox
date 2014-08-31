{-# LANGUAGE FlexibleContexts, RankNTypes, TemplateHaskell #-}

module Controller.Update
    ( contents
    ) where

import Control.Applicative
import Control.Monad (when)
import Control.Monad.Error (catchError)
import Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Control.Monad.State as State
import Control.Monad.Trans.Class (lift)
import Data.Aeson (Value, ToJSON(toJSON))
import Data.Aeson.TH (deriveJSON, defaultOptions, fieldLabelModifier)
import Data.Bifunctor (bimap)
import Data.Int (Int64)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import qualified Data.Set as Set
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
import DataSource (Connection)
import qualified Query
import qualified Table.Office as O
import qualified Table.OfficeHistory as OH
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
  deriving (Show, Read)

deriveJSON defaultOptions ''FileAction

data UpdateData = UpdateData
    { index :: Integer
    , action :: FileAction
    , table :: String
    , pkColumn :: String
    , data' :: [[String]]
    }

deriveJSON defaultOptions{fieldLabelModifier = initIf (=='\'')} ''UpdateData

-- | from-toからidとactionのセットを取得するSQL
history :: C.History a
    => Relation () a -- ^ テーブルのRelation
    -> Pi a Int64 -- ^ from toで指定するキー
    -> Relation (Int64, Int64) (Int64, String)
history historyRelation k = relation' $ do
    h <- query historyRelation
    (ph, ()) <- placeholder $ \range -> wheres $
        (h ! k .>. range ! fst') `and'`
        (h ! k .<. range ! snd')
    desc $ h ! k
    return (ph, (h ! C.id' >< h ! C.action'))

(...) :: (d -> c) -> (a -> b -> d) -> (a -> b -> c)
(...) = (.) . (.)

-- | したテーブルからfrom,toの間に更新されたエントリの
--   id,actionの組のリストを取得
targetHistories :: (MonadIO m, FromSql SqlValue a, C.History a)
    => Connection
    -> Relation () a -- ^ テーブルSQL
    -> Pi a Int64 -- ^ from, toのキー
    -> VersionupHisIds -- ^ from
    -> VersionupHisIds -- ^ to
    -> m [(Int64, String)]
targetHistories conn r k =
    Query.runQuery conn (history r k) ... curry (bimap oid oid)
  where
    oid = fromIntegral . officeId

inIdList :: (Integral i, Num j, ShowConstantTermsSQL j)
    => Relation () a -> Pi a j -> [i] -> Relation () a
inIdList rel k ids = relation $ do
    o <- query rel
    wheres $ o ! k `in'` values (map fromIntegral ids)
    return o

content :: (MonadIO m, FromSql SqlValue a, Ord a, C.History a, ToJSON a)
    => Relation () a -> Pi a Int64
    -> VersionupHisIds -> VersionupHisIds -> m [Value]
content r k from to = Query.query $ \conn ->
    uniq <$> targetHistories conn r k from to >>= f conn
  where
    uniq = Set.toList . Set.fromList
    f _    [] = return []
    f conn hs = do
        -- TODO: actionがDELETEの時にも対応する
        -- TODO: これをさらにUpdateDataに詰めて返す
        map toJSON <$> Query.runQuery conn (inIdList O.office O.officeId' $ map fst hs) ()
        error "tmp"

updateContent :: MonadIO m
    => VersionupHisIds -> VersionupHisIds -> m (Map String [Value])
updateContent from to = flip State.execStateT Map.empty $ do
    lift (content OH.officeHistory OH.id' from to)
        >>= State.modify . addData . toJSON
    undefined
  where
    addData = addData' DATA
    addData' k v m = Map.insert k' (v:fromMaybe [] (Map.lookup k' m)) m
      where
        k' = show k

contents :: Auth -> ActionM ()
contents _ = do
    req <- parseParams "req"
    let from = androidDataIds req
        to   = serverDataIds req
    when (from == to) $ fail "already updated"
    updateContent from to >>= Scotty.json
  `catchError` \e -> do
    liftIO $ print $ Scotty.showError e
    clientError
