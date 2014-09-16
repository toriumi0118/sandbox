{-# LANGUAGE QuasiQuotes #-}

module Main where

import Data.Char (toUpper, toLower)
import Data.List (intercalate)
import Data.Maybe (catMaybes)
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
    flip mapM_ names $ \(tab, mod) ->
        withFile (fileName mod) WriteMode $ \h ->
            hPutStr h $ content typ tab mod
  where
    names = zip tableNames $ map toModuleName tableNames
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

extensions :: [String] -> String
extensions es = [i|{-# LANGUAGE ${v} #-}|]
  where
    v = intercalate ", " es

template :: String -> String -> String -> String -> String -> String
template tableName moduleName exts exmods inmods = [i|${exts}

module Table.${moduleName} where

${exmods}

${inmods}

defineTable "${tableName}"
deriveJSON defaultOptions ''${moduleName}
|]

content :: TableType -> String -> String -> String
content Standard tableName moduleName =
    template tableName moduleName exts exmods inmods
  where
    exts = extensions
        [ "TemplateHaskell"
        , "MultiParamTypeClasses"
        , "FlexibleInstances"
        ]
    exmods = intercalate "\n"
        [ "import Data.Aeson.TH (deriveJSON, defaultOptions)"
        ]
    inmods = intercalate "\n"
        [ "import DataSource (defineTable)"
        ]
content (Versionup keyName) tableName moduleName =
    template tableName moduleName exts exmods inmods
    ++ [i|mkFields ''${moduleName}

tableContext :: TableContext ${moduleName}
tableContext = TableContext
    ${relName}
    ${relKeyName}
    ${relKeyName'}
    "${tableName}"
    "${keyName}"
    fields
    NoParam
|]
  where
    relName = headLower moduleName
    relKeyBase = headLower $ toModuleName keyName
    relKeyName = if moduleName `elem` intList
        then [i|(fromIntegral . ${relKeyBase})|]
        else relKeyBase
    relKeyName' = if moduleName `elem` intList
        then "(fromIntegral |$| " ++ relKeyBase ++ "')"
        else relKeyBase ++ "'"
    exts = extensions
        [ "TemplateHaskell"
        , "MultiParamTypeClasses"
        , "FlexibleInstances"
        ]
    exmods = intercalate "\n" $ catMaybes $
        Just "import Data.Aeson.TH (deriveJSON, defaultOptions)"
        :(if moduleName `elem` intList
            then Just "import Database.Relational.Query ((|$|))"
            else Nothing)
        :(if relKeyBase == "id"
            then Just "import Prelude hiding (id)"
            else Nothing)
        :[]
    inmods = intercalate "\n"
        [ "import Controller.Types.Class ()"
        , "import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))"
        , "import DataSource (defineTable)"
        , "import TH (mkFields)"
        ]

intList :: [String]
intList =
    [ "OfficeCaseRel"
    , "OfficeImageCom"
    , "OfficePdf"
    , "Catalog"
    ]
