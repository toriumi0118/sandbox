module DataSource
    ( connect
    , defineTable
    , Connection
    ) where

import Database.HDBC.Query.TH (defineTableFromDB)
import Database.Record.TH (derivingShow)
import Language.Haskell.TH

import Config (loadConfig, Config(..))
import qualified DataSource.MySQL as MySQL
import DataSource.Types (Connection)

connect :: IO Connection
connect = loadConfig >>= MySQL.connect

reserved :: Name -> Bool
reserved n = show n `elem` ["id", "type", "data"]

alias :: Name -> (Name, Type) -> Q [Dec]
alias ptName (n, t) = sequence
    [ sigD tName (appT (appT arrowT (conT ptName)) (return t))
    , valD (varP tName) (normalB (varE n)) []
    ]
  where
    tName = mkName $ show n ++ "_"

defineTable :: String -> DecsQ
defineTable table = do
    c <- runIO loadConfig
    ds@(DataD _ ptName _ [RecC _ ls] _:_) <- defineTableFromDB
        (MySQL.connect c)
        MySQL.driver
        (dbSchema c)
        table
        [derivingShow]
    let nts = filter (reserved . fst) $ map (\(n, _, t) -> (n, t)) ls
    decs <- mapM (alias ptName) nts
    return $ ds ++ concat decs
