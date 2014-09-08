{-# LANGUAGE QuasiQuotes #-}

module Main where

import Data.Char (toUpper)
import Data.String.Here (i)
import Prelude hiding (mod)
import System.Environment (getArgs)
import System.IO (withFile, hPutStr, IOMode(WriteMode))

main :: IO ()
main = do
    tableNames <- getArgs
    let names = zip tableNames $ map toModuleName tableNames
    if length tableNames == 0
        then putStrLn "Usage: createtable tableName.."
        else flip mapM_ names $ \(tab, mod) ->
            withFile (fileName mod) WriteMode $ \h ->
                hPutStr h $ content tab mod
  where
    fileName moduleName = "src/Table/" ++ moduleName ++ ".hs"

split :: Eq a => a -> [a] -> [[a]]
split = f [] []
  where
    f rs a _ [] = reverse (reverse a:rs)
    f rs a s (b:bs)
        | s == b    = f (reverse a:rs) [] s bs
        | otherwise = f rs (b:a) s bs

capitalize :: String -> String
capitalize []     = []
capitalize (c:cs) = toUpper c:cs

toModuleName :: String -> String
toModuleName = concat . map capitalize . split '_'

content :: String -> String -> String
content tableName moduleName = [i|
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.${moduleName} where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

defineTable "${tableName}"

deriveJSON defaultOptions ''${moduleName}
|]
