{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}

module Controller.Types.Class
    ( PostParam(parseParams)
    , deriveParam
    ) where

import Data.Monoid (mconcat)
import Data.Text.Lazy (Text)
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Web.Scotty (ActionM, param)

class PostParam a where
    parseParams :: Text -> ActionM a

fst3 :: (a, b, c) -> a
fst3 (a, _, _) = a

-- x <- param $ LT.pack $ concat [name, "." fname]
getParamS :: Name -> VarStrictType -> Q (Name, StmtQ)
getParamS name (fname, _, _) = do
    x <- newName "x"
    return (x, bindS (varP x)
        [|param (mconcat
            [$(varE name), ".", $(stringE $ nameBase fname)])|])

deriveParam :: Name -> DecsQ
deriveParam dat = do
    (TyConI (DataD _ _ _ [RecC dConst vsTypes] _)) <- reify dat
    name <- newName "name"
    binds <- mapM (getParamS name) vsTypes
    let con = appsE (conE dConst:map (varE . fst) binds)
    let body = normalB
            (doE (map snd binds ++ [noBindS (appE (varE 'return) con)]))
    d <- instanceD
        (cxt [])
        [t|PostParam $(conT dat)|]
        [funD 'parseParams [clause [varP name] body []]]
    return [d]
