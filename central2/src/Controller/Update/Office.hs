{-# LANGUAGE FlexibleContexts #-}

module Controller.Update.Office
    ( updateData
    ) where

import Control.Monad.IO.Class (MonadIO)

import Controller.Update.DataProvider (DataProvider)
import Controller.Update.UpdateData (updatedData)
import qualified Table.BusinessTime
import qualified Table.DementiaBusinessTime
import qualified Table.DementiaServiceTime
import qualified Table.DementiaVacancy
import qualified Table.Office
import qualified Table.OfficeAppealPoint
import qualified Table.OfficeContract
import qualified Table.OfficeDementia
import qualified Table.OfficeImageCom
import qualified Table.OfficeLicence
import qualified Table.OfficePrice
import qualified Table.OfficeUserInfo
import qualified Table.RelAcupressureTherapist
import qualified Table.RelAddFee
import qualified Table.RelAddFeeHelpWorker
import qualified Table.RelAddFeePrecaution
import qualified Table.RelAddFeeWorker
import qualified Table.RelAlcohol
import qualified Table.RelArchitecture
import qualified Table.RelAttendantBed
import qualified Table.RelBathJet
import qualified Table.RelBathMachine
import qualified Table.RelBathMicroBubble
import qualified Table.RelBathOnsen
import qualified Table.RelBathSameSex
import qualified Table.RelBathTime
import qualified Table.RelBathType
import qualified Table.RelBathWay
import qualified Table.RelBigTv
import qualified Table.RelBrainTraining
import qualified Table.RelBusinessKind
import qualified Table.RelCarLogo
import qualified Table.RelDementiaAddFee
import qualified Table.RelDementiaAddFeeHelpWorker
import qualified Table.RelDementiaAddFeePrecaution
import qualified Table.RelDementiaAddFeeWorker
import qualified Table.RelDementiaEndingCourse
import qualified Table.RelDementiaFloor
import qualified Table.RelDementiaHelpLevel
import qualified Table.RelDementiaJudge
import qualified Table.RelDementiaStudy
import qualified Table.RelDementiaType
import qualified Table.RelDesign
import qualified Table.RelDoseManage
import qualified Table.RelDriveRange
import qualified Table.RelDriveTime
import qualified Table.RelElevator
import qualified Table.RelExperiencePrice
import qualified Table.RelExtra
import qualified Table.RelFacility
import qualified Table.RelFemaleDay
import qualified Table.RelFingerTranslator
import qualified Table.RelFloorCnt
import qualified Table.RelHealthMachine
import qualified Table.RelHelpLevel
import qualified Table.RelHiyari
import qualified Table.RelHotline
import qualified Table.RelInfoDiscovery
import qualified Table.RelLandClass
import qualified Table.RelLocalCommunication
import qualified Table.RelMaleDay
import qualified Table.RelMassage
import qualified Table.RelMealBreakfast
import qualified Table.RelMealBuffet
import qualified Table.RelMealDietician
import qualified Table.RelMealDinner
import qualified Table.RelMealDrink
import qualified Table.RelMealKampo
import qualified Table.RelMealLaunch
import qualified Table.RelMealMadeIn
import qualified Table.RelMealMenu
import qualified Table.RelMealOut
import qualified Table.RelMealPlace
import qualified Table.RelMealSnack
import qualified Table.RelMealStart
import qualified Table.RelMedical
import qualified Table.RelMedicalDay
import qualified Table.RelMidnightMeal
import qualified Table.RelNewspaper
import qualified Table.RelNight
import qualified Table.RelNurseCall
import qualified Table.RelOralCare
import qualified Table.RelOrientalMedicine
import qualified Table.RelPeeSameSex
import qualified Table.RelPet
import qualified Table.RelRecreation
import qualified Table.RelRehabMachine
import qualified Table.RelRemodeling
import qualified Table.RelScale
import qualified Table.RelSelfOut
import qualified Table.RelSingleCare
import qualified Table.RelSmoking
import qualified Table.RelSocialAid
import qualified Table.RelSpeechTherapist
import qualified Table.RelSpecialField
import qualified Table.RelStayNight
import qualified Table.RelSuperPlayer
import qualified Table.RelTerminalCare
import qualified Table.RelUserTablet
import qualified Table.RelViolence
import qualified Table.RelVolunteer
import qualified Table.RelWheelchair
import qualified Table.RelWithBuilding
import qualified Table.RelWithPet
import qualified Table.ServiceTime
import qualified Table.Vacancy

updateData :: (MonadIO m, Functor m) => DataProvider m ()
updateData = do
    updatedData Table.Office.tableContext
    updatedData Table.OfficePrice.tableContext
    updatedData Table.OfficeUserInfo.tableContext
    updatedData Table.OfficeLicence.tableContext
    updatedData Table.OfficeDementia.tableContext
    updatedData Table.OfficeContract.tableContext
    updatedData Table.RelSpecialField.tableContext
    updatedData Table.RelWithPet.tableContext
    updatedData Table.RelLandClass.tableContext
    updatedData Table.RelAddFee.tableContext
    updatedData Table.RelAddFeeWorker.tableContext
    updatedData Table.RelAddFeePrecaution.tableContext
    updatedData Table.RelAddFeeHelpWorker.tableContext
    updatedData Table.RelHelpLevel.tableContext
    updatedData Table.RelDementiaAddFee.tableContext
    updatedData Table.RelDementiaAddFeeWorker.tableContext
    updatedData Table.RelDementiaAddFeePrecaution.tableContext
    updatedData Table.RelDementiaAddFeeHelpWorker.tableContext
    updatedData Table.RelDementiaType.tableContext
    updatedData Table.RelDementiaHelpLevel.tableContext
    updatedData Table.RelDementiaJudge.tableContext
    updatedData Table.RelDementiaStudy.tableContext
    updatedData Table.RelDementiaFloor.tableContext
    updatedData Table.RelFloorCnt.tableContext
    updatedData Table.RelArchitecture.tableContext
    updatedData Table.RelElevator.tableContext
    updatedData Table.RelDesign.tableContext
    updatedData Table.RelRemodeling.tableContext
    updatedData Table.RelWheelchair.tableContext
    updatedData Table.RelSingleCare.tableContext
    updatedData Table.RelOralCare.tableContext
    updatedData Table.RelTerminalCare.tableContext
    updatedData Table.RelExtra.tableContext
    updatedData Table.RelNight.tableContext
    updatedData Table.RelDriveTime.tableContext
    updatedData Table.RelDriveRange.tableContext
    updatedData Table.RelAttendantBed.tableContext
    updatedData Table.RelCarLogo.tableContext
    updatedData Table.RelSelfOut.tableContext
    updatedData Table.RelInfoDiscovery.tableContext
    updatedData Table.RelDoseManage.tableContext
    updatedData Table.RelSocialAid.tableContext
    updatedData Table.RelPeeSameSex.tableContext
    updatedData Table.RelHiyari.tableContext
    updatedData Table.RelHotline.tableContext
    updatedData Table.RelVolunteer.tableContext
    updatedData Table.RelMassage.tableContext
    updatedData Table.RelMealStart.tableContext
    updatedData Table.RelMealMenu.tableContext
    updatedData Table.RelMealPlace.tableContext
    updatedData Table.RelMealDietician.tableContext
    updatedData Table.RelMealMadeIn.tableContext
    updatedData Table.RelMealDinner.tableContext
    updatedData Table.RelMealDrink.tableContext
    updatedData Table.RelMealBuffet.tableContext
    updatedData Table.RelMealOut.tableContext
    updatedData Table.RelMealKampo.tableContext
    updatedData Table.RelMealSnack.tableContext
    updatedData Table.RelBathSameSex.tableContext
    updatedData Table.RelBathJet.tableContext
    updatedData Table.RelNewspaper.tableContext
    updatedData Table.RelUserTablet.tableContext
    updatedData Table.RelBrainTraining.tableContext
    updatedData Table.RelBigTv.tableContext
    updatedData Table.RelBusinessKind.tableContext
    updatedData Table.RelExperiencePrice.tableContext
    updatedData Table.RelPet.tableContext
    updatedData Table.RelWithBuilding.tableContext
    updatedData Table.RelScale.tableContext
    updatedData Table.RelDementiaEndingCourse.tableContext
    updatedData Table.RelNurseCall.tableContext
    updatedData Table.RelFacility.tableContext
    updatedData Table.RelSuperPlayer.tableContext
    updatedData Table.RelMaleDay.tableContext
    updatedData Table.RelFemaleDay.tableContext
    updatedData Table.RelStayNight.tableContext
    updatedData Table.RelRecreation.tableContext
    updatedData Table.RelMedical.tableContext
    updatedData Table.RelMedicalDay.tableContext
    updatedData Table.RelLocalCommunication.tableContext
    updatedData Table.RelOrientalMedicine.tableContext
    updatedData Table.RelBathMachine.tableContext
    updatedData Table.RelBathType.tableContext
    updatedData Table.RelBathWay.tableContext
    updatedData Table.RelBathOnsen.tableContext
    updatedData Table.RelBathTime.tableContext
    updatedData Table.RelHealthMachine.tableContext
    updatedData Table.RelRehabMachine.tableContext
    updatedData Table.RelMidnightMeal.tableContext
    updatedData Table.RelSpeechTherapist.tableContext
    updatedData Table.RelAcupressureTherapist.tableContext
    updatedData Table.BusinessTime.tableContext
    updatedData Table.DementiaBusinessTime.tableContext
    updatedData Table.Vacancy.tableContext
    updatedData Table.DementiaVacancy.tableContext
    updatedData Table.ServiceTime.tableContext
    updatedData Table.DementiaServiceTime.tableContext
    updatedData Table.RelViolence.tableContext
    updatedData Table.RelFingerTranslator.tableContext
    updatedData Table.OfficeImageCom.tableContext
    updatedData Table.OfficeAppealPoint.tableContext
    updatedData Table.RelMealBreakfast.tableContext
    updatedData Table.RelBathMicroBubble.tableContext
    updatedData Table.RelAlcohol.tableContext
    updatedData Table.RelSmoking.tableContext
    updatedData Table.RelMealLaunch.tableContext
