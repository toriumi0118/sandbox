module Main where

import Crypto.Hash (SHA256(SHA256))
import qualified Crypto.Hash as Hash
import Data.Byteable (toBytes)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Base64 as Base64
import Data.Maybe (fromMaybe)
import Data.UnixTime (UnixTime)
import qualified Data.UnixTime as UnixTime
import Network.Http.Client (RequestBuilder, Hostname, Method(..), ContentType)
import qualified Network.Http.Client as Http
import qualified Network.URI as URI
import qualified OpenSSL.Session as SSL
import qualified System.IO.Streams as Streams

whenJust :: Monad m => Maybe a -> (a -> m ()) -> m ()
whenJust Nothing  _ = return ()
whenJust (Just a) f = f a

type AccountName = ByteString
type SecretKey = ByteString

setHeadersForTable
    :: AccountName
    -> SecretKey
    -> Hostname
    -> Method
    -> Maybe ByteString -- ^ Content-MD5
    -> Maybe ContentType
    -> UnixTime
    -> ByteString -- ^ Resource
    -> RequestBuilder ()
setHeadersForTable acc key host verb cmd5 ctype date resource = do
    Http.setHostname host 443
    Http.http verb resource
    Http.setAccept "application/json;odata=nometadata"
    Http.setHeader "x-ms-date"
        $ UnixTime.formatUnixTimeGMT UnixTime.webDateFormat date
    Http.setHeader "MaxDataServiceVersion" "3.0;NetFx"
    whenJust cmd5 $ Http.setHeader "Content-MD5"
    whenJust ctype $ Http.setContentType
    Http.setHeader "Authorization" authorization
  where
    stringToSign = BS.intercalate "\n"
        [ BC.pack $ show verb
        , fromMaybe "" cmd5
        , fromMaybe "" ctype
        , ""
        , BS.concat ["/", acc, resource]
        ]
    signature = Base64.encode $ toBytes $ Hash.hmacAlg SHA256 key stringToSign
--    signature = Base64.encode $ LBS.toStrict $ SHA.bytestringDigest $ SHA.sha256 stringToSign
    authorization = BS.concat
        [ "SharedKey "
        , acc
        , ":"
        , BC.pack . URI.escapeURIString p . BC.unpack $ signature
        ]
    p '/' = False
    p '#' = False
    p _   = True

main :: IO ()
main = do
    time <- UnixTime.getUnixTime
    sslContext <- SSL.context
    let host = "welmokpilog.table.core.windows.net"
    conn <- Http.openConnectionSSL sslContext host 443
    req <- Http.buildRequest $ do
        setHeadersForTable
            "welmokpilog"
            "LfXCQBPcj4u313vfz+mx+pGC2fWwnhAo+2UW5SVAnAqIjYBEPt76oievOM3LpV35BwYCYi6ufeSBRZCs/h3c8Q=="
            host
            GET
            Nothing
            Nothing
            time
            "/Tables"
    print req

    Http.sendRequest conn req Http.emptyBody
    Http.receiveResponse conn $ \res i -> do
        print res
        ma <- Streams.read i
        case ma of
            Just a -> BC.putStrLn a
            Nothing -> return ()
    Http.closeConnection conn
