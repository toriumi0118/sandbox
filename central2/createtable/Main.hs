{-# LANGUAGE QuasiQuotes #-}

module Main where

import Data.Char (toUpper, toLower)
import Data.String.Here (i)
import Prelude hiding (mod)
import System.Environment (getArgs)
import System.IO (withFile, hPutStr, IOMode(WriteMode))

main :: IO ()
main = do
    tableNames <- getArgs
    case tableNames of
        []        -> do
            putStrLn "Usage: createtable [Option] tableName.."
            putStrLn "\t-s key: Synchronized"
        ("-s":k:ts) -> createTable ts $ Versionup k
        (_:_)     -> createTable tableNames Standard

data TableType = Standard | Versionup String

createTable :: [String] -> TableType -> IO ()
createTable tableNames typ = do
    let names = zip tableNames $ map toModuleName tableNames
    flip mapM_ names $ \(tab, mod) ->
        withFile (fileName mod) WriteMode $ \h ->
            hPutStr h $ content typ tab mod
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

headLower :: String -> String
headLower []     = []
headLower (c:cs) = toLower c:cs

content :: TableType -> String -> String -> String
content Standard tableName moduleName = [i|
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.${moduleName} where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

defineTable "${tableName}"

deriveJSON defaultOptions ''${moduleName}
|]
content (Versionup keyName) tableName moduleName = [i|
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.${moduleName} where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.UpdateData (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "${tableName}"
deriveJSON defaultOptions ''${moduleName}
mkFields ''${moduleName}

tableContext :: TableContext ${moduleName}
tableContext = TableContext
    ${relName}
    ${relKeyName}
    ${relKeyName}'
    "${tableName}"
    "${keyName}"
    fields
|]
  where
    relName = headLower moduleName
    relKeyName = headLower $ toModuleName keyName
