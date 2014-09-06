{-# LANGUAGE QuasiQuotes #-}

module Main where

import Data.Char (toUpper)
import Data.String.Here (i)
import System.Environment (getArgs)
import System.IO (withFile, hPutStr, IOMode(WriteMode))

main :: IO ()
main = do
    args <- getArgs
    let tableName = args !! 0
    let moduleName = toModuleName tableName
    if length args == 0
        then putStrLn "Usage: createtable tableName"
        else withFile (fileName moduleName) WriteMode $ \h ->
            hPutStr h $ content tableName moduleName
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
