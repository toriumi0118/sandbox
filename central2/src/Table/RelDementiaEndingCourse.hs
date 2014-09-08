
{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaEndingCourse where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import DataSource (defineTable)
import Table.Types (TableContext(TableContext))
import TH (mkFields)

defineTable "rel_dementia_ending_course"
deriveJSON defaultOptions ''RelDementiaEndingCourse
mkFields ''RelDementiaEndingCourse

tableContext :: TableContext
tableContext = TableContext
    relDementiaEndingCourse
    officeId
    officeId'
    "rel_dementia_ending_course"
    "office_id"
    fields
