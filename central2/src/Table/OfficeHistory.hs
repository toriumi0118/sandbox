{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.OfficeHistory where

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Prelude hiding (id)

import Controller.Types.Class (History)
import DataSource (defineTable)

defineTable "office_history"

deriveJSON defaultOptions ''OfficeHistory

instance Eq OfficeHistory where
    a == b = officeId a == officeId b

instance Ord OfficeHistory where
    a <= b = officeId a <= officeId b

instance History OfficeHistory
