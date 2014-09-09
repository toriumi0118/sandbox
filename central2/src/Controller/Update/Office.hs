module Controller.Update.Office
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, DataProvider(Default), updatedData)
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

updateData :: UpdatedDataList
updateData conn hs =
    [ updatedData Default conn hs Table.Office.tableContext
    , updatedData Default conn hs Table.OfficePrice.tableContext
    , updatedData Default conn hs Table.OfficeUserInfo.tableContext
    , updatedData Default conn hs Table.OfficeLicence.tableContext
    , updatedData Default conn hs Table.OfficeDementia.tableContext
    , updatedData Default conn hs Table.OfficeContract.tableContext
    , updatedData Default conn hs Table.RelSpecialField.tableContext
    , updatedData Default conn hs Table.RelWithPet.tableContext
    , updatedData Default conn hs Table.RelLandClass.tableContext
    , updatedData Default conn hs Table.RelAddFee.tableContext
    , updatedData Default conn hs Table.RelAddFeeWorker.tableContext
    , updatedData Default conn hs Table.RelAddFeePrecaution.tableContext
    , updatedData Default conn hs Table.RelAddFeeHelpWorker.tableContext
    , updatedData Default conn hs Table.RelHelpLevel.tableContext
    , updatedData Default conn hs Table.RelDementiaAddFee.tableContext
    , updatedData Default conn hs Table.RelDementiaAddFeeWorker.tableContext
    , updatedData Default conn hs Table.RelDementiaAddFeePrecaution.tableContext
    , updatedData Default conn hs Table.RelDementiaAddFeeHelpWorker.tableContext
    , updatedData Default conn hs Table.RelDementiaType.tableContext
    , updatedData Default conn hs Table.RelDementiaHelpLevel.tableContext
    , updatedData Default conn hs Table.RelDementiaJudge.tableContext
    , updatedData Default conn hs Table.RelDementiaStudy.tableContext
    , updatedData Default conn hs Table.RelDementiaFloor.tableContext
    , updatedData Default conn hs Table.RelFloorCnt.tableContext
    , updatedData Default conn hs Table.RelArchitecture.tableContext
    , updatedData Default conn hs Table.RelElevator.tableContext
    , updatedData Default conn hs Table.RelDesign.tableContext
    , updatedData Default conn hs Table.RelRemodeling.tableContext
    , updatedData Default conn hs Table.RelWheelchair.tableContext
    , updatedData Default conn hs Table.RelSingleCare.tableContext
    , updatedData Default conn hs Table.RelOralCare.tableContext
    , updatedData Default conn hs Table.RelTerminalCare.tableContext
    , updatedData Default conn hs Table.RelExtra.tableContext
    , updatedData Default conn hs Table.RelNight.tableContext
    , updatedData Default conn hs Table.RelDriveTime.tableContext
    , updatedData Default conn hs Table.RelDriveRange.tableContext
    , updatedData Default conn hs Table.RelAttendantBed.tableContext
    , updatedData Default conn hs Table.RelCarLogo.tableContext
    , updatedData Default conn hs Table.RelSelfOut.tableContext
    , updatedData Default conn hs Table.RelInfoDiscovery.tableContext
    , updatedData Default conn hs Table.RelDoseManage.tableContext
    , updatedData Default conn hs Table.RelSocialAid.tableContext
    , updatedData Default conn hs Table.RelPeeSameSex.tableContext
    , updatedData Default conn hs Table.RelHiyari.tableContext
    , updatedData Default conn hs Table.RelHotline.tableContext
    , updatedData Default conn hs Table.RelVolunteer.tableContext
    , updatedData Default conn hs Table.RelMassage.tableContext
    , updatedData Default conn hs Table.RelMealStart.tableContext
    , updatedData Default conn hs Table.RelMealMenu.tableContext
    , updatedData Default conn hs Table.RelMealPlace.tableContext
    , updatedData Default conn hs Table.RelMealDietician.tableContext
    , updatedData Default conn hs Table.RelMealMadeIn.tableContext
    , updatedData Default conn hs Table.RelMealDinner.tableContext
    , updatedData Default conn hs Table.RelMealDrink.tableContext
    , updatedData Default conn hs Table.RelMealBuffet.tableContext
    , updatedData Default conn hs Table.RelMealOut.tableContext
    , updatedData Default conn hs Table.RelMealKampo.tableContext
    , updatedData Default conn hs Table.RelMealSnack.tableContext
    , updatedData Default conn hs Table.RelBathSameSex.tableContext
    , updatedData Default conn hs Table.RelBathJet.tableContext
    , updatedData Default conn hs Table.RelNewspaper.tableContext
    , updatedData Default conn hs Table.RelUserTablet.tableContext
    , updatedData Default conn hs Table.RelBrainTraining.tableContext
    , updatedData Default conn hs Table.RelBigTv.tableContext
    , updatedData Default conn hs Table.RelBusinessKind.tableContext
    , updatedData Default conn hs Table.RelExperiencePrice.tableContext
    , updatedData Default conn hs Table.RelPet.tableContext
    , updatedData Default conn hs Table.RelWithBuilding.tableContext
    , updatedData Default conn hs Table.RelScale.tableContext
    , updatedData Default conn hs Table.RelDementiaEndingCourse.tableContext
    , updatedData Default conn hs Table.RelNurseCall.tableContext
    , updatedData Default conn hs Table.RelFacility.tableContext
    , updatedData Default conn hs Table.RelSuperPlayer.tableContext
    , updatedData Default conn hs Table.RelMaleDay.tableContext
    , updatedData Default conn hs Table.RelFemaleDay.tableContext
    , updatedData Default conn hs Table.RelStayNight.tableContext
    , updatedData Default conn hs Table.RelRecreation.tableContext
    , updatedData Default conn hs Table.RelMedical.tableContext
    , updatedData Default conn hs Table.RelMedicalDay.tableContext
    , updatedData Default conn hs Table.RelLocalCommunication.tableContext
    , updatedData Default conn hs Table.RelOrientalMedicine.tableContext
    , updatedData Default conn hs Table.RelBathMachine.tableContext
    , updatedData Default conn hs Table.RelBathType.tableContext
    , updatedData Default conn hs Table.RelBathWay.tableContext
    , updatedData Default conn hs Table.RelBathOnsen.tableContext
    , updatedData Default conn hs Table.RelBathTime.tableContext
    , updatedData Default conn hs Table.RelHealthMachine.tableContext
    , updatedData Default conn hs Table.RelRehabMachine.tableContext
    , updatedData Default conn hs Table.RelMidnightMeal.tableContext
    , updatedData Default conn hs Table.RelSpeechTherapist.tableContext
    , updatedData Default conn hs Table.RelAcupressureTherapist.tableContext
    , updatedData Default conn hs Table.BusinessTime.tableContext
    , updatedData Default conn hs Table.DementiaBusinessTime.tableContext
    , updatedData Default conn hs Table.Vacancy.tableContext
    , updatedData Default conn hs Table.DementiaVacancy.tableContext
    , updatedData Default conn hs Table.ServiceTime.tableContext
    , updatedData Default conn hs Table.DementiaServiceTime.tableContext
    , updatedData Default conn hs Table.RelViolence.tableContext
    , updatedData Default conn hs Table.RelFingerTranslator.tableContext
    , updatedData Default conn hs Table.OfficeImageCom.tableContext
    , updatedData Default conn hs Table.OfficeAppealPoint.tableContext
    , updatedData Default conn hs Table.RelMealBreakfast.tableContext
    , updatedData Default conn hs Table.RelBathMicroBubble.tableContext
    , updatedData Default conn hs Table.RelAlcohol.tableContext
    , updatedData Default conn hs Table.RelSmoking.tableContext
    , updatedData Default conn hs Table.RelMealLaunch.tableContext
    ]
