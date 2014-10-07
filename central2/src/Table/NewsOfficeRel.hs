
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsOfficeRel where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import DataSource (defineTable)

defineTable "news_office_rel"

deriveJSON defaultOptions ''NewsOfficeRel
