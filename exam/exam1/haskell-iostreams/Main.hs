module Main where

import Control.Applicative
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.State as State
import Data.Attoparsec (Parser)
import qualified Data.Attoparsec.ByteString.Char8 as P
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BC
import Data.Char (toLower)
import Data.List (sortBy)
import qualified Data.Map.Strict as Map
import Data.Ord (Down(Down), comparing)
import System.Environment (getArgs)
import System.IO.Streams (InputStream)
import qualified System.IO.Streams as Stream
import qualified System.IO.Streams.Attoparsec as SA

skip :: Parser ()
skip = P.skipWhile (not . P.isAlpha_ascii)

word :: Parser ByteString
word = P.takeWhile P.isAlpha_ascii <* skip

char :: Parser ByteString
char = P.take 1 <* skip

firstLetter :: Parser ByteString
firstLetter = P.take 1 <* P.takeWhile P.isAlpha_ascii <* skip

count :: InputStream ByteString -> IO [(ByteString, Int)]
count is = Map.toList <$> State.execStateT f Map.empty
  where
    f = liftIO (Stream.read is) >>=
        maybe (return ()) (\a -> State.modify (Map.alter g $ l a) >> f)
    g Nothing  = Just 1
    g (Just n) = Just $ n + 1
    l = BC.map toLower

exam1 :: FilePath -> Parser ByteString -> IO ()
exam1 file parser = do
    r <- Stream.withFileAsInput file $ \is -> do
        ws <- SA.parserToInputStream p is
        count ws
    print $ sortBy (comparing $ Down . snd) r
  where
    p = (P.endOfInput >> return Nothing) <|> (Just <$> parser)

main :: IO ()
main = do
    args <- getArgs
    if length args < 2
        then putStrLn "Usage: exam1 [123] inputfile"
        else case args !! 0 of
            "1" -> exam1 (args !! 1) word
            "2" -> exam1 (args !! 1) char
            "3" -> exam1 (args !! 1) firstLetter
            n   -> fail $ "unknown number=" ++ n
