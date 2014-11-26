module Cloud.Azure.Storage.Core
    ( StorageAccount
      ( accountName
      , accountKey
      )
    , storageAccount
    ) where

import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BC

data AuthType = SharedKey | SharedKeyLite deriving (Show)
type AccountName = ByteString
type AccountKey = ByteString
type Signature = ByteString

data StorageAccount = StorageAccount
    { accountName :: AccountName
    , accountKey :: AccountKey
    }

storageAccount
    :: String -- ^ Account name
    -> String -- ^ Account key
    -> StorageAccount
storageAccount name key = StorageAccount
    (BC.pack name)
    (BC.pack key)
