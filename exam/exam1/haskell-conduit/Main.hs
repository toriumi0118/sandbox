module Main where

import Control.Applicative
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Resource (runResourceT)
import qualified Control.Monad.Trans.State.Strict as State
import Data.Attoparsec (Parser)
import qualified Data.Attoparsec.ByteString.Char8 as P
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BC
import Data.Char (toLower)
import Data.Conduit
import qualified Data.Conduit.Binary as CB
import qualified Data.Conduit.Attoparsec as CA
import Data.List (sortBy)
import qualified Data.Map.Strict as Map
import Data.Ord (Down(Down), comparing)
import System.Environment (getArgs)

skip :: Parser ()
skip = P.skipWhile (not . P.isAlpha_ascii)

word :: Parser ByteString
word = P.takeWhile P.isAlpha_ascii <* skip

char :: Parser ByteString
char = P.take 1 <* skip

firstLetter :: Parser ByteString
firstLetter = P.take 1 <* P.takeWhile P.isAlpha_ascii <* skip

printSink :: (Show i, MonadIO m) => Consumer i m ()
printSink = await >>= maybe (return ()) (\a -> liftIO (print a) >> printSink)

counter :: (Monad m, Ord i, Show i) => Consumer i m [(i, Int)]
counter = Map.toList <$> State.execStateT f Map.empty
  where
    f = lift await >>= maybe (return ()) (\a -> State.modify (Map.alter g a) >> f)
    g Nothing  = Just 1
    g (Just n) = Just $ n + 1

exam1 :: FilePath -> Parser ByteString -> IO ()
exam1 file p = do
    r <- runResourceT $ CB.sourceFile file
        $= mapOutput f (CA.conduitParser $ skip *> p)
        $$ counter
    print $ sortBy (comparing $ Down . snd) r
  where
    f = BC.map toLower . snd

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
