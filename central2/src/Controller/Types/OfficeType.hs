module Controller.Types.OfficeType
    ( OfficeType(..)
    ) where

data OfficeType
    = DayService
    | ServiceBuilding

instance Read OfficeType where
    readsPrec _ "day_service"      = [(DayService, "")]
    readsPrec _ "service_building" = [(ServiceBuilding, "")]
    readsPrec _ _                  = []
