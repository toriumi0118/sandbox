{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelatedOfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class ()
import DataSource (defineTable)

defineTable "related_office_history"

deriveJSON defaultOptions ''RelatedOfficeHistory
