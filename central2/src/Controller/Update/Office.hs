module Controller.Update.Office
    ( updateData
    ) where

import Controller.Update.UpdateData (UpdatedDataList, updatedData)
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
    [ updatedData conn hs Table.Office.tableContext
    , updatedData conn hs Table.OfficePrice.tableContext
    , updatedData conn hs Table.OfficeUserInfo.tableContext
    , updatedData conn hs Table.OfficeLicence.tableContext
    , updatedData conn hs Table.OfficeDementia.tableContext
    , updatedData conn hs Table.OfficeContract.tableContext
    , updatedData conn hs Table.RelSpecialField.tableContext
    , updatedData conn hs Table.RelWithPet.tableContext
    , updatedData conn hs Table.RelLandClass.tableContext
    , updatedData conn hs Table.RelAddFee.tableContext
    , updatedData conn hs Table.RelAddFeeWorker.tableContext
    , updatedData conn hs Table.RelAddFeePrecaution.tableContext
    , updatedData conn hs Table.RelAddFeeHelpWorker.tableContext
    , updatedData conn hs Table.RelHelpLevel.tableContext
    , updatedData conn hs Table.RelDementiaAddFee.tableContext
    , updatedData conn hs Table.RelDementiaAddFeeWorker.tableContext
    , updatedData conn hs Table.RelDementiaAddFeePrecaution.tableContext
    , updatedData conn hs Table.RelDementiaAddFeeHelpWorker.tableContext
    , updatedData conn hs Table.RelDementiaType.tableContext
    , updatedData conn hs Table.RelDementiaHelpLevel.tableContext
    , updatedData conn hs Table.RelDementiaJudge.tableContext
    , updatedData conn hs Table.RelDementiaStudy.tableContext
    , updatedData conn hs Table.RelDementiaFloor.tableContext
    , updatedData conn hs Table.RelFloorCnt.tableContext
    , updatedData conn hs Table.RelArchitecture.tableContext
    , updatedData conn hs Table.RelElevator.tableContext
    , updatedData conn hs Table.RelDesign.tableContext
    , updatedData conn hs Table.RelRemodeling.tableContext
    , updatedData conn hs Table.RelWheelchair.tableContext
    , updatedData conn hs Table.RelSingleCare.tableContext
    , updatedData conn hs Table.RelOralCare.tableContext
    , updatedData conn hs Table.RelTerminalCare.tableContext
    , updatedData conn hs Table.RelExtra.tableContext
    , updatedData conn hs Table.RelNight.tableContext
    , updatedData conn hs Table.RelDriveTime.tableContext
    , updatedData conn hs Table.RelDriveRange.tableContext
    , updatedData conn hs Table.RelAttendantBed.tableContext
    , updatedData conn hs Table.RelCarLogo.tableContext
    , updatedData conn hs Table.RelSelfOut.tableContext
    , updatedData conn hs Table.RelInfoDiscovery.tableContext
    , updatedData conn hs Table.RelDoseManage.tableContext
    , updatedData conn hs Table.RelSocialAid.tableContext
    , updatedData conn hs Table.RelPeeSameSex.tableContext
    , updatedData conn hs Table.RelHiyari.tableContext
    , updatedData conn hs Table.RelHotline.tableContext
    , updatedData conn hs Table.RelVolunteer.tableContext
    , updatedData conn hs Table.RelMassage.tableContext
    , updatedData conn hs Table.RelMealStart.tableContext
    , updatedData conn hs Table.RelMealMenu.tableContext
    , updatedData conn hs Table.RelMealPlace.tableContext
    , updatedData conn hs Table.RelMealDietician.tableContext
    , updatedData conn hs Table.RelMealMadeIn.tableContext
    , updatedData conn hs Table.RelMealDinner.tableContext
    , updatedData conn hs Table.RelMealDrink.tableContext
    , updatedData conn hs Table.RelMealBuffet.tableContext
    , updatedData conn hs Table.RelMealOut.tableContext
    , updatedData conn hs Table.RelMealKampo.tableContext
    , updatedData conn hs Table.RelMealSnack.tableContext
    , updatedData conn hs Table.RelBathSameSex.tableContext
    , updatedData conn hs Table.RelBathJet.tableContext
    , updatedData conn hs Table.RelNewspaper.tableContext
    , updatedData conn hs Table.RelUserTablet.tableContext
    , updatedData conn hs Table.RelBrainTraining.tableContext
    , updatedData conn hs Table.RelBigTv.tableContext
    , updatedData conn hs Table.RelBusinessKind.tableContext
    , updatedData conn hs Table.RelExperiencePrice.tableContext
    , updatedData conn hs Table.RelPet.tableContext
    , updatedData conn hs Table.RelWithBuilding.tableContext
    , updatedData conn hs Table.RelScale.tableContext
    , updatedData conn hs Table.RelDementiaEndingCourse.tableContext
    , updatedData conn hs Table.RelNurseCall.tableContext
    , updatedData conn hs Table.RelFacility.tableContext
    , updatedData conn hs Table.RelSuperPlayer.tableContext
    , updatedData conn hs Table.RelMaleDay.tableContext
    , updatedData conn hs Table.RelFemaleDay.tableContext
    , updatedData conn hs Table.RelStayNight.tableContext
    , updatedData conn hs Table.RelRecreation.tableContext
    , updatedData conn hs Table.RelMedical.tableContext
    , updatedData conn hs Table.RelMedicalDay.tableContext
    , updatedData conn hs Table.RelLocalCommunication.tableContext
    , updatedData conn hs Table.RelOrientalMedicine.tableContext
    , updatedData conn hs Table.RelBathMachine.tableContext
    , updatedData conn hs Table.RelBathType.tableContext
    , updatedData conn hs Table.RelBathWay.tableContext
    , updatedData conn hs Table.RelBathOnsen.tableContext
    , updatedData conn hs Table.RelBathTime.tableContext
    , updatedData conn hs Table.RelHealthMachine.tableContext
    , updatedData conn hs Table.RelRehabMachine.tableContext
    , updatedData conn hs Table.RelMidnightMeal.tableContext
    , updatedData conn hs Table.RelSpeechTherapist.tableContext
    , updatedData conn hs Table.RelAcupressureTherapist.tableContext
    , updatedData conn hs Table.BusinessTime.tableContext
    , updatedData conn hs Table.DementiaBusinessTime.tableContext
    , updatedData conn hs Table.Vacancy.tableContext
    , updatedData conn hs Table.DementiaVacancy.tableContext
    , updatedData conn hs Table.ServiceTime.tableContext
    , updatedData conn hs Table.DementiaServiceTime.tableContext
    , updatedData conn hs Table.RelViolence.tableContext
    , updatedData conn hs Table.RelFingerTranslator.tableContext
    , updatedData conn hs Table.OfficeImageCom.tableContext
    , updatedData conn hs Table.OfficeAppealPoint.tableContext
    , updatedData conn hs Table.RelMealBreakfast.tableContext
    , updatedData conn hs Table.RelBathMicroBubble.tableContext
    , updatedData conn hs Table.RelAlcohol.tableContext
    , updatedData conn hs Table.RelSmoking.tableContext
    , updatedData conn hs Table.RelMealLaunch.tableContext
    ]
