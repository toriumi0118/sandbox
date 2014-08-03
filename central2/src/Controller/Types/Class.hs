{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleInstances #-}

module Controller.Types.Class
    ( PostParam(..)
    , deriveParam
    ) where

import Control.Monad.Error.Class (catchError)
import Data.Maybe (catMaybes)
import Data.Monoid
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy.Builder as LTB
import qualified Data.Text.Lazy.Builder.Int as LTB
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Web.Scotty (ActionM, param)

class PostParam a where
    parseParams :: Text -> ActionM a
    parseParams prefix = parseParams' prefix Nothing
    parseParams' :: Text -> Maybe Text -> ActionM a

instance PostParam a => PostParam[a] where
    parseParams' prefix _ = f prefix [0..]

f :: PostParam a => Text -> [Int] -> ActionM [a]
f _      []     = fail "not reached"
f prefix (n:ns) = do
    a <- parseParams' (prefix <> br) Nothing
    as <- f prefix ns `catchError` \_ -> return []
    return $ a:as
  where
    toText = LTB.toLazyText . LTB.decimal
    br = "[" <> toText n <> "]"

fst3 :: (a, b, c) -> a
fst3 (a, _, _) = a

-- x <- param $ mconcat $ catMaybes [Just pname, Just ".", Just fname, sname]
getParamS :: Name -> Name -> VarStrictType -> Q (Name, StmtQ)
getParamS pname sname (fname, _, _) = do
    x <- newName "x"
    return (x, bindS (varP x)
        [|param (mconcat (catMaybes
            [ Just $(varE pname)
            , Just "."
            , Just $(stringE $ nameBase fname)
            , $(varE sname)
            ]))
         |])

deriveParam :: Name -> DecsQ
deriveParam dat = do
    (TyConI (DataD _ _ _ [RecC dConst vsTypes] _)) <- reify dat
    let pname = mkName "prefix"
    let sname = mkName "msuffix"
    binds <- mapM (getParamS pname sname) vsTypes
    let con = appsE (conE dConst:map (varE . fst) binds)
    let expr = doE (map snd binds ++ [noBindS [|return $con|]])
    [d|
        instance PostParam $(conT dat) where
            parseParams' prefix msuffix = $expr
      |]
