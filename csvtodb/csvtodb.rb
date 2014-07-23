
require 'active_record'

load 'lib/connection.rb'

def usage
  puts "Usage: #{$0} input.csv"
end

def business_kind_store(f, list, business_kind, office_id, office_no)
  RelBusinessKind.delete_all(:office_id => office_id)

  return if business_kind.nil?

  business_kind.split(/\R/).each {|b|
    kind = list.select {|k| k.name == b }.first
    if kind.nil? then
      puts "WARNING: unknown kind(office_id=%d, kind=%s)" % [office_id, b]
      f.puts "%d,%d,%s" % [office_id, office_no, b]
      next
    end
    RelBusinessKind.create!(:office_id => office_id, :attr_id => kind.id)
  }
end

def business_time_store(office_id, bt0_from, bt0_to, bt5_from, bt5_to, bt6_from, bt6_to, bt7_from, bt7_to)
  BusinessTime.delete_all(:office_id => office_id)
  if !bt0_from.nil? && !bt0_to.nil? then
    (0..4).each {|i|
      BusinessTime.create(
        :office_id => office_id,
        :day_id => i,
        :from_date_hm => bt0_from.to_i,
        :to_date_hm => bt0_to.to_i
      )
    }
  end
  if !bt5_from.nil? && !bt5_to.nil? then
    BusinessTime.create(
      :office_id => office_id,
      :day_id => 5,
      :from_date_hm => bt5_from.to_i,
      :to_date_hm => bt5_to.to_i
    )
  end
  if !bt6_from.nil? && !bt6_to.nil? then
    BusinessTime.create(
      :office_id => office_id,
      :day_id => 6,
      :from_date_hm => bt6_from.to_i,
      :to_date_hm => bt6_to.to_i
    )
  end
  if !bt7_from.nil? && !bt7_to.nil? then
    BusinessTime.create(
      :office_id => office_id,
      :day_id => 7,
      :from_date_hm => bt7_from.to_i,
      :to_date_hm => bt7_to.to_i
    )
  end
end

def delete_all_rel(office_id)
  [   "rel_acupressure_therapist",
      "rel_add_fee_help_worker",
      "rel_add_fee_precaution",
      "rel_alcohol",
      "rel_architecture",
      "rel_attendant_bed",
      "rel_bath_jet",
      "rel_bath_machine",
      "rel_bath_micro_bubble",
      "rel_bath_onsen",
      "rel_bath_same_sex",
      "rel_bath_time",
      "rel_bath_type",
      "rel_bath_way",
      "rel_big_tv",
      "rel_brain_training",
      "rel_car_logo",
      "rel_dementia_add_fee",
      "rel_dementia_add_fee_help_worker",
      "rel_dementia_add_fee_precaution",
      "rel_dementia_add_fee_worker",
      "rel_dementia_ending_course",
      "rel_dementia_floor",
      "rel_dementia_help_level",
      "rel_dementia_judge",
      "rel_dementia_study",
      "rel_dementia_type",
      "rel_design",
      "rel_dose_manage",
      "rel_drive_range",
      "rel_drive_time",
      "rel_elevator",
      "rel_experience_price",
      "rel_facility",
      "rel_female_day",
      "rel_finger_translator",
      "rel_floor_cnt",
      "rel_health_machine",
      "rel_hiyari",
      "rel_hotline",
      "rel_info_discovery",
      "rel_kyotaku_care_add_fee_other",
      "rel_kyotaku_care_add_fee_service",
      "rel_kyotaku_care_add_fee_staff",
      "rel_kyotaku_right_defense",
      "rel_kyotaku_service_area",
      "rel_kyotaku_tell_emergency",
      "rel_land_class",
      "rel_local_communication",
      "rel_male_day",
      "rel_massage",
      "rel_meal_breakfast",
      "rel_meal_buffet",
      "rel_meal_dietician",
      "rel_meal_dinner",
      "rel_meal_drink",
      "rel_meal_kampo",
      "rel_meal_made_in",
      "rel_meal_menu",
      "rel_meal_out",
      "rel_meal_place",
      "rel_meal_snack",
      "rel_meal_start",
      "rel_medical",
      "rel_medical_day",
      "rel_midnight_meal",
      "rel_mood",
      "rel_newspaper",
      "rel_night",
      "rel_nurse_call",
      "rel_oral_care",
      "rel_oriental_medicine",
      "rel_pee_same_sex",
      "rel_pet",
      "rel_recreation",
      "rel_rehab_machine",
      "rel_remodeling",
      "rel_scale",
      "rel_self_out",
      "rel_single_care",
      "rel_smoking",
      "rel_social_aid",
      "rel_special_field",
      "rel_speech_therapist",
      "rel_stay_night",
      "rel_super_player",
      "rel_terminal_care",
      "rel_user_tablet",
      "rel_violence",
      "rel_volunteer",
      "rel_wheelchair",
      "rel_with_building",
      "rel_with_pet"].each do |t|
    ActiveRecord::Base.connection.delete("delete from #{t} where office_id = #{office_id}")
  end
end

def main
  file = if $*.length == 0 then
    puts "no input file."
    usage
    exit
  else
    $*.shift
  end

  connect
  
  require 'csv'
  load 'lib/tables.rb'
  
  csv = CSV.read(file, encoding:"utf-8")
  csv.shift 

  maxid = Office.maximum(:office_id)
  if maxid.nil? then
    puts "office table is empty."
    exit
  end

  office_contracts = OfficeContract.all.map {|o| o.office_id }
  business_kinds = AttrBusinessKind.all

  transaction {
    open("warn.csv", "w") {|f|
      csv.each {|row|
        office_no,
          office_name,
          company,
          address,
          latitude,
          longitude,
          tel,
          fax,
          help_level,
          vacancy,
          extra,
          add_fee1,
          add_fee2,
          add_fee3,
          add_fee4,
          add_fee5,
          add_fee6,
          add_fee7,
          add_fee8,
          add_fee9,
          add_fee_worker1,
          add_fee_worker2,
          add_fee_worker3,
          meal_biko,
          morning,
          launch,
          dinner,
          snack,
          nurse,
          pt_nurse,
          staff_cnt,
          business_kind,
          bt0_from,
          bt0_to,
          bt5_from,
          bt5_to,
          bt6_from,
          bt6_to,
          bt7_from,
          bt7_to,
          drive_range_biko,
          founding_day = row
  
        office = Office.where(["office_no = ?", office_no]).first
        if office.nil? then
          maxid += 1
          office = Office.new(:office_id => maxid, :office_no => office_no)
        else
          next if office_contracts.include? office.office_id
          delete_all_rel(office.office_id)
        end
        office.name = office_name
        office.company = company
        office.address = address
        office.latitude = latitude
        office.longitude = longitude
        office.tel = tel
        office.fax = fax
        office.staff_cnt = staff_cnt.to_f.ceil
        office.drive_range_biko = drive_range_biko
        office.founding_day = founding_day
        office.long_vacation = nil
        office.save!
  
        RelHelpLevel.delete_all(:office_id => office.office_id)
        RelHelpLevel.create!(:office_id => office.office_id, :attr_id => 0) if help_level == "1"
  
        Vacancy.delete_all(:office_id => office.office_id)
        (0..5).each {|i|
          Vacancy.create!(
            :office_id => office.office_id,
            :day_id => i,
            :term_ord => 0,
            :capacity_cnt => vacancy
          )
        }
  
        RelExtra.delete_all(:office_id => office.office_id)
        RelExtra.create!(:office_id => office.office_id, :attr_id => 0) if extra == "1"
  
        RelAddFee.delete_all(:office_id => office.office_id)
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 11) if add_fee1 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 12) if add_fee2 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 13) if add_fee3 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 5) if add_fee4 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 6) if add_fee5 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 4) if add_fee6 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 7) if add_fee7 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 8) if add_fee8 == "1"
        RelAddFee.create!(:office_id => office.office_id, :attr_id => 9) if add_fee9 == "1"
  
        RelAddFeeWorker.delete_all(:office_id => office.office_id)
        RelAddFeeWorker.create!(:office_id => office.office_id, :attr_id => 0) if add_fee_worker1 == "1"
        RelAddFeeWorker.create!(:office_id => office.office_id, :attr_id => 1) if add_fee_worker2 == "1"
        RelAddFeeWorker.create!(:office_id => office.office_id, :attr_id => 2) if add_fee_worker3 == "1"
  
        office_price = OfficePrice.where(["office_id = ?", office.office_id]).first
        if office_price.nil? then
          office_price = OfficePrice.new(:office_id => office.office_id)
        end
        office_price.meal_biko = meal_biko
        office_price.morning = morning
        office_price.launch = launch
        office_price.dinner = dinner
        office_price.snack = snack
        office_price.save!
  
        office_license = OfficeLicence.where(["office_id = ?", office.office_id]).first
        if office_license.nil? then
          office_license = OfficeLicence.new(:office_id => office.office_id)
        end
        office_license.nurse = nurse.to_f.ceil
        office_license.pt_nurse = pt_nurse.to_f.ceil
        office_license.save!
  
        business_kind_store(f, business_kinds, business_kind, office.office_id, office_no)

        business_time_store(office.office_id, bt0_from, bt0_to, bt5_from, bt5_to, bt6_from, bt6_to, bt7_from, bt7_to)
	
        OfficeHistory.create(
          :office_id => office.office_id,
	  :editor => "nomura csv to db",
	  :action => "UPDATE"
        )
      }
    }
#    raise "dry run"
  }
end

main
