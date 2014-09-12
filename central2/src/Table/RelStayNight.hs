{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module Table.RelStayNight where

import Data.Aeson.TH (deriveJSON, defaultOptions)

import Controller.Types.Class ()
import Controller.Update.TableContext (TableContext(TableContext), TableContextParam(NoParam))
import DataSource (defineTable)
import TH (mkFields)

defineTable "rel_stay_night"
deriveJSON defaultOptions ''RelStayNight
mkFields ''RelStayNight

tableContext :: TableContext RelStayNight
tableContext = TableContext
    relStayNight
    officeId
    officeId'
    "rel_stay_night"
    "office_id"
    fields
    NoParam
