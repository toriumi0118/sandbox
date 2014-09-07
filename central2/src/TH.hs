{-# LANGUAGE QuasiQuotes, TemplateHaskell #-}

module TH where

import Control.Lens
import Data.Char (toLower)
import Language.Haskell.TH

fields :: Name -> DecsQ
fields name = do
    (TyConI (DataD _ _ _ [RecC _ vsts] _)) <- reify name
    let rs = listE $ map (litE . stringL . baseName . show . fst3) vsts
    fun <- valD (varP funName) (normalB rs) []
    dec <- sigD funName [t|[String]|]
    return [dec, fun]
  where
    toCamel [] = []
    toCamel (c:cs) = toLower c:cs
    funName = mkName $ toCamel (baseName $ show name) ++ "Fields"
    fst3 (a,_,_) = a
    baseName = last . split '.'
    split sp = f [] []
      where
        f rs a [] = reverse $ reverse a:rs
        f rs a (x:xs)
            | x == sp = f (reverse a:rs) [] xs
            | otherwise = f rs (x:a) xs

makeLenses' :: Name -> Q [Dec]
makeLenses' = makeLensesWith (lensRules & lensField .~ myFieldToDef)
  where
    myFieldToDef _ n = [TopName (mkName (nameBase n))]
