module Controller.Update.HistoryContext
    ( HistoryContext
        ( HistoryContext
        , tableRel
        , pk
        , historyKey
        )
    ) where

import Data.Int (Int64)
import Database.Relational.Query (Relation, Pi)

import Controller.Types.VersionupHisIds (VersionupHisIds)

data HistoryContext a = HistoryContext
    { tableRel :: Relation () a
    , pk :: Pi a Int64
    , historyKey :: VersionupHisIds -> Integer
    }
