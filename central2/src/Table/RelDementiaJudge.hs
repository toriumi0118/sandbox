{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelDementiaJudge where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_dementia_judge"
deriveJSON defaultOptions ''RelDementiaJudge
mkFields ''RelDementiaJudge

tableContext :: TableContext RelDementiaJudge
tableContext = TableContext
    relDementiaJudge
    officeId
    officeId'
    "rel_dementia_judge"
    "office_id"
    fields
    Nothing
