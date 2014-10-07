
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.NewsBody where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import DataSource (defineTable)

defineTable "news_body"

deriveJSON defaultOptions ''NewsBody
