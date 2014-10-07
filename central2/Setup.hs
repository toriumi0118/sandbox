import Control.Applicative
import Control.Monad (unless, when)
import Data.List (delete)
import Distribution.PackageDescription
import Distribution.Simple
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.Setup
import System.Directory (getModificationTime)
import System.Process (shell, createProcess)

createtable :: String
createtable = "createtable"

isModifiedTables :: FilePath -> [String] -> IO Bool
isModifiedTables buildDir tgts = do
    t <- getModificationTime $ target createtable
    ts <- mapM (getModificationTime . target) tgts
    return $ or $ map (t >) ts
  where
    target p = concat [buildDir, "/", p, "/", p]

nullThen :: [b] -> [b] -> [b]
nullThen as [] = as
nullThen _  bs = bs

myBuildHook
    :: (PackageDescription -> LocalBuildInfo -> UserHooks -> BuildFlags -> IO ())
    -> PackageDescription -> LocalBuildInfo -> UserHooks -> BuildFlags -> IO ()
myBuildHook defHook desc info hooks flags =
    buildProc $ nullThen exes $ buildArgs flags
  where
    build tgt = defHook desc info hooks flags{buildArgs = tgt}
    exes = map exeName $ executables desc
    others = delete createtable
    cmd p = do
        putStrLn $ "exec: " ++ p
        _ <- createProcess $ shell p
        return ()
    buildProc tgts = do
        build [createtable]
        m <- isModifiedTables (buildDir info) tgts
        when m $ cmd "./mkhistorytable.sh"
        let tgts' = others tgts
        unless (null tgts') $ build tgts'

customUserHooks :: UserHooks
customUserHooks = simpleUserHooks
    { buildHook = myBuildHook (buildHook simpleUserHooks)
    }

main :: IO ()
main = defaultMainWithHooks customUserHooks
