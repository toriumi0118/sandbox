{-# LANGUAGE TypeOperators, DataKinds #-}

module Main where

import Crypto.Hash (SHA256(SHA256))
import qualified Crypto.Hash as Hash
import Data.Byteable (toBytes)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Base64 as Base64
import Data.Maybe (fromMaybe)
import Data.Monoid ((<>))
import Data.UnixTime (UnixTime)
import qualified Data.UnixTime as UnixTime
import Network.Http.Client (Connection, RequestBuilder, Hostname, Port, Method(..), ContentType)
import qualified Network.Http.Client as Http
import qualified OpenSSL.Session as SSL
import qualified System.IO.Streams as Streams

import Cloud.Azure.Storage.Core

data AuthType = SharedKey | SharedKeyLite deriving (Show)
type AccountName = ByteString
type AccountKey = ByteString
type Signature = ByteString

authorizationHeader :: AuthType -> AccountName -> Signature -> ByteString
authorizationHeader atype acc sig = BS.concat
    [BC.pack (show atype), " ", acc, ":", sig]

formatDate :: UnixTime -> ByteString
formatDate = UnixTime.formatUnixTimeGMT UnixTime.webDateFormat

stringToSign
    :: Method
    -> Maybe ByteString -- ^ Content-MD5
    -> Maybe ContentType
    -> UnixTime
    -> AccountName
    -> ByteString -- ^ Resource
    -> ByteString
stringToSign verb md5 ctype date acc resource = BS.intercalate "\n"
    [ BC.pack $ show verb
    , fromMaybe "" md5
    , fromMaybe "" ctype
    , formatDate date
    , BS.concat ["/", acc, resource]
    ]

fromEither :: a -> Either b a -> a
fromEither _ (Right a) = a
fromEither a _         = a

signature :: AccountKey -> ByteString -> ByteString
signature key
    = Base64.encode
    . toBytes
    . Hash.hmacAlg SHA256 (fromEither key $ Base64.decode key)

whenJust :: Monad m => Maybe a -> (a -> m ()) -> m ()
whenJust Nothing  _ = return ()
whenJust (Just a) f = f a

setHeadersForTable
    :: AccountName
    -> AccountKey
    -> Hostname
    -> Method
    -> Maybe ByteString -- ^ Content-MD5
    -> Maybe ContentType
    -> UnixTime
    -> ByteString -- ^ Resource
    -> RequestBuilder ()
setHeadersForTable acc key host verb md5 ctype date resource = do
    Http.setHostname host 443
    Http.http verb resource
    Http.setAccept "application/json;odata=nometadata"
    Http.setHeader "Date" $ formatDate date
    Http.setHeader "DataServiceVersion" "3.0"
    Http.setHeader "x-ms-version" "2014-02-14"
    Http.setHeader "Accept-Encoding" "UTF-8"
    whenJust md5 $ Http.setHeader "Content-MD5"
    whenJust ctype $ Http.setContentType
    Http.setHeader "Authorization"
        $ authorizationHeader SharedKey acc
        $ signature key
        $ stringToSign verb md5 ctype date acc resource

withConnection :: Hostname -> Port -> (Connection -> IO a) -> IO a
withConnection host port f = do
    sslContext <- SSL.context
    Http.withConnection (Http.openConnectionSSL sslContext host port) f

runStorageTable
    :: StorageAccount
    -> Hostname
    -> IO ()
runStorageTable acc host = do
    time <- UnixTime.getUnixTime
    withConnection host 443 $ \conn -> do
        req <- Http.buildRequest $ do
            setHeadersForTable
                (accountName acc)
                (accountKey acc)
                host
                GET
                Nothing
                (Just "application/json")
                time
                "/Tables"
        print req

        Http.sendRequest conn req Http.emptyBody
        Http.receiveResponse conn $ \res i -> do
            print res
            Streams.read i >>= maybe (return ()) BC.putStrLn

main :: IO ()
main = do
    let acc = storageAccount
            "welmokpilog"
            "LfXCQBPcj4u313vfz+mx+pGC2fWwnhAo+2UW5SVAnAqIjYBEPt76oievOM3LpV35BwYCYi6ufeSBRZCs/h3c8Q=="
    let host = accountName acc <> ".table.core.windows.net"
    runStorageTable acc host
