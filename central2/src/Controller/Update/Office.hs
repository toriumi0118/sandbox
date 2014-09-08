module Controller.Update.Office
    ( updateData
    ) where

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
import Table.Types (TableContext)

updateData :: [TableContext]
updateData =
    [ Table.Office.tableContext
    , Table.OfficePrice.tableContext
    , Table.OfficeUserInfo.tableContext
    , Table.OfficeLicence.tableContext
    , Table.OfficeDementia.tableContext
    , Table.OfficeContract.tableContext
    , Table.RelSpecialField.tableContext
    , Table.RelWithPet.tableContext
    , Table.RelLandClass.tableContext
    , Table.RelAddFee.tableContext
    , Table.RelAddFeeWorker.tableContext
    , Table.RelAddFeePrecaution.tableContext
    , Table.RelAddFeeHelpWorker.tableContext
    , Table.RelHelpLevel.tableContext
    , Table.RelDementiaAddFee.tableContext
    , Table.RelDementiaAddFeeWorker.tableContext
    , Table.RelDementiaAddFeePrecaution.tableContext
    , Table.RelDementiaAddFeeHelpWorker.tableContext
    , Table.RelDementiaType.tableContext
    , Table.RelDementiaHelpLevel.tableContext
    , Table.RelDementiaJudge.tableContext
    , Table.RelDementiaStudy.tableContext
    , Table.RelDementiaFloor.tableContext
    , Table.RelFloorCnt.tableContext
    , Table.RelArchitecture.tableContext
    , Table.RelElevator.tableContext
    , Table.RelDesign.tableContext
    , Table.RelRemodeling.tableContext
    , Table.RelWheelchair.tableContext
    , Table.RelSingleCare.tableContext
    , Table.RelOralCare.tableContext
    , Table.RelTerminalCare.tableContext
    , Table.RelExtra.tableContext
    , Table.RelNight.tableContext
    , Table.RelDriveTime.tableContext
    , Table.RelDriveRange.tableContext
    , Table.RelAttendantBed.tableContext
    , Table.RelCarLogo.tableContext
    , Table.RelSelfOut.tableContext
    , Table.RelInfoDiscovery.tableContext
    , Table.RelDoseManage.tableContext
    , Table.RelSocialAid.tableContext
    , Table.RelPeeSameSex.tableContext
    , Table.RelHiyari.tableContext
    , Table.RelHotline.tableContext
    , Table.RelVolunteer.tableContext
    , Table.RelMassage.tableContext
    , Table.RelMealStart.tableContext
    , Table.RelMealMenu.tableContext
    , Table.RelMealPlace.tableContext
    , Table.RelMealDietician.tableContext
    , Table.RelMealMadeIn.tableContext
    , Table.RelMealDinner.tableContext
    , Table.RelMealDrink.tableContext
    , Table.RelMealBuffet.tableContext
    , Table.RelMealOut.tableContext
    , Table.RelMealKampo.tableContext
    , Table.RelMealSnack.tableContext
    , Table.RelBathSameSex.tableContext
    , Table.RelBathJet.tableContext
    , Table.RelNewspaper.tableContext
    , Table.RelUserTablet.tableContext
    , Table.RelBrainTraining.tableContext
    , Table.RelBigTv.tableContext
    , Table.RelBusinessKind.tableContext
    , Table.RelExperiencePrice.tableContext
    , Table.RelPet.tableContext
    , Table.RelWithBuilding.tableContext
    , Table.RelScale.tableContext
    , Table.RelDementiaEndingCourse.tableContext
    , Table.RelNurseCall.tableContext
    , Table.RelFacility.tableContext
    , Table.RelSuperPlayer.tableContext
    , Table.RelMaleDay.tableContext
    , Table.RelFemaleDay.tableContext
    , Table.RelStayNight.tableContext
    , Table.RelRecreation.tableContext
    , Table.RelMedical.tableContext
    , Table.RelMedicalDay.tableContext
    , Table.RelLocalCommunication.tableContext
    , Table.RelOrientalMedicine.tableContext
    , Table.RelBathMachine.tableContext
    , Table.RelBathType.tableContext
    , Table.RelBathWay.tableContext
    , Table.RelBathOnsen.tableContext
    , Table.RelBathTime.tableContext
    , Table.RelHealthMachine.tableContext
    , Table.RelRehabMachine.tableContext
    , Table.RelMidnightMeal.tableContext
    , Table.RelSpeechTherapist.tableContext
    , Table.RelAcupressureTherapist.tableContext
    , Table.BusinessTime.tableContext
    , Table.DementiaBusinessTime.tableContext
    , Table.Vacancy.tableContext
    , Table.DementiaVacancy.tableContext
    , Table.ServiceTime.tableContext
    , Table.DementiaServiceTime.tableContext
    , Table.RelViolence.tableContext
    , Table.RelFingerTranslator.tableContext
    , Table.OfficeImageCom.tableContext
    , Table.OfficeAppealPoint.tableContext
    , Table.RelMealBreakfast.tableContext
    , Table.RelBathMicroBubble.tableContext
    , Table.RelAlcohol.tableContext
    , Table.RelSmoking.tableContext
    , Table.RelMealLaunch.tableContext
    ]
