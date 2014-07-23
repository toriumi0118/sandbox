# coding: utf-8
require 'active_record'

load 'lib/connection.rb'

def usage
  puts "Usage: #{$0} input.csv"
end

def srv_area_store(f, list, srv_area, office_id, office_no)
  RelKyotakuServiceArea.delete_all(:office_id => office_id)

  return if srv_area.nil?

  srv_area.split(/\R/).each {|s|
    area = list.select {|k| k.name == s }.first
    if area.nil? then
      puts "WARNING: unknown area(office_id=%d, area=%s)" % [office_id, s]
      f.puts "%d,%d,%s" % [office_id, office_no, s]
      next
    end
    RelKyotakuServiceArea.create!(:office_id => office_id, :attr_id => area.id)
  }
end

def business_time_store(office_id, bt0_from, bt0_to, bt5_from, bt5_to, bt6_from, bt6_to, bt7_from, bt7_to)
  KyotakuBusinessTime.delete_all(:office_id => office_id)
  if !bt0_from.nil? && !bt0_to.nil? then
    (0..4).each {|i|
      KyotakuBusinessTime.create(
        :office_id => office_id,
        :day_id => i,
        :from_date_hm => bt0_from.to_i,
        :to_date_hm => bt0_to.to_i
      )
    }
  end
  if !bt5_from.nil? && !bt5_to.nil? then
    KyotakuBusinessTime.create(
      :office_id => office_id,
      :day_id => 5,
      :from_date_hm => bt5_from.to_i,
      :to_date_hm => bt5_to.to_i
    )
  end
  if !bt6_from.nil? && !bt6_to.nil? then
    KyotakuBusinessTime.create(
      :office_id => office_id,
      :day_id => 6,
      :from_date_hm => bt6_from.to_i,
      :to_date_hm => bt6_to.to_i
    )
  end
  if !bt7_from.nil? && !bt7_to.nil? then
    KyotakuBusinessTime.create(
      :office_id => office_id,
      :day_id => 7,
      :from_date_hm => bt7_from.to_i,
      :to_date_hm => bt7_to.to_i
    )
  end
end

def delete_all_rel(office_id)
  [   "rel_kyotaku_care_add_fee_other",
      "rel_kyotaku_care_add_fee_service",
      "rel_kyotaku_care_add_fee_staff",
      "rel_kyotaku_right_defense",
      "rel_kyotaku_service_area",
      "rel_kyotaku_tell_emergency"].each do |t|
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

  maxid = Kyotaku.maximum(:office_id)
  if maxid.nil? then
    puts "kyotaku table is empty."
    exit
  end

  srv_areas = AttrKyotakuServiceArea.all

  transaction {
    open("warn.csv", "w") {|f|
      csv.each {|row|
          office_name,
          office_no,
          company,
          tell,
          tell_emergency_ari,
          tell_emergency,
          fax,
          address,
          latitude,
          longitude,
          hp,
          delegate,
          founding_day,
          srv_area,
          srv_area_biko,
          bt0_from,
          bt0_to,
          bt5_from,
          bt5_to,
          bt6_from,
          bt6_to,
          bt7_from,
          bt7_to,
          long_vacation,
          user_per_cm,
          cm_cnt,
          cm_cnt_pt,
          cm_cnt_chief,
          cm_cnt_chief_pt,
          cm_5_old,
          cm_male,
          cm_female,
          doctor,
          doctor_pt,
          dentist,
          dentist_pt,
          dispenser,
          dispenser_pt,
          health_nurse,
          health_nurse_pt,
          midwife,
          midwife_pt,
          nurse,
          nurse_pt,
          semi_nurse,
          semi_nurse_pt,
          physical_therapist,
          physical_therapist_pt,
          work_therapist,
          work_therapist_pt,
          speech_therapist,
          speech_therapist_pt,
          social_worker,
          social_worker_pt,
          care_worker,
          care_worker_pt,
          strategist_training,
          strategist_training_pt,
          staff_ground_training,
          staff_ground_training_pt,
          orthoptist,
          orthoptist_pt,
          prosthetist,
          prosthetist_pt,
          dental_hygienist,
          dental_hygienist_pt,
          acupressure_therapist,
          acupressure_therapist_pt,
          acupuncture_therapist,
          acupuncture_therapist_pt,
          moxacautery_therapist,
          moxacautery_therapist_pt,
          judo_therapist,
          judo_therapist_pt,
          dietician,
          dietician_pt,
          managerial_dietician,
          managerial_dietician_pt,
          psychiatric_social_worker,
          psychiatric_social_worker_pt,
          add_fee_staff1,
          add_fee_staff2,
          add_fee1,
          add_fee2,
          add_fee3,
          add_fee4,
          add_fee5,
          add_fee6,
          add_fee_other1,
          add_fee_other2 = row
  
        puts "process in %s(%d)" % [office_name, office_no]

        kyotaku = Kyotaku.where(["office_no = ?", office_no]).first
        if kyotaku.nil? then
          maxid += 1
          kyotaku = Kyotaku.new(:office_id => maxid, :office_no => office_no)
        else
          delete_all_rel(kyotaku.office_id)
        end
        kyotaku.name = office_name
        kyotaku.company = company
        kyotaku.address = address
        kyotaku.tell = tell
        kyotaku.tell_emergency = tell_emergency
        kyotaku.fax = fax
        kyotaku.hp_address = hp
        kyotaku.delegate = delegate
        kyotaku.founding_day = founding_day
        kyotaku.cm_cnt_rate = user_per_cm
        kyotaku.cm_cnt = cm_cnt
        kyotaku.cm_pt_cnt = cm_cnt_pt
        kyotaku.cm_cnt_chief = cm_cnt_chief
        kyotaku.cm_pt_cnt_chief = cm_cnt_chief_pt
        kyotaku.cm_cnt_5year_career = cm_5_old
        kyotaku.cm_cnt_male = cm_male
        kyotaku.cm_cnt_female = cm_female
        kyotaku.service_area_biko = srv_area_biko
        kyotaku.long_vacation = long_vacation
        kyotaku.latitude = latitude
        kyotaku.longitude = longitude
        kyotaku.prc_date = nil
        kyotaku.save!
  
        RelKyotakuTellEmergency.delete_all(:office_id => kyotaku.office_id)
        if tell_emergency_ari == "1" then
          RelKyotakuTellEmergency.create!(:office_id => kyotaku.office_id, :attr_id => 0)
        else
          puts "WARNING: no tell emergency(office_id=%d, office_no=%d)" % [kyotaku.office_id, kyotaku.office_no]
          f.puts "%d,%d,%s" % [kyotaku.office_id, office_no, "no tell emergency"]
        end

        srv_area_store(f, srv_areas, srv_area, kyotaku.office_id, office_no)

        business_time_store(kyotaku.office_id, bt0_from, bt0_to, bt5_from, bt5_to, bt6_from, bt6_to, bt7_from, bt7_to)

        license = KyotakuLicense.where(["office_id = ?", kyotaku.office_id]).first
        if license.nil? then
          license = KyotakuLicense.new(:office_id => kyotaku.office_id)
        end
        license.doctor = doctor 
        license.doctor_pt = doctor_pt 
        license.dentist = dentist 
        license.dentist_pt = dentist_pt 
        license.dispenser = dispenser 
        license.dispenser_pt = dispenser_pt 
        license.health_nurse = health_nurse 
        license.health_nurse_pt = health_nurse_pt 
        license.midwife = midwife 
        license.midwife_pt = midwife_pt 
        license.nurse = nurse 
        license.nurse_pt = nurse_pt 
        license.semi_nurse = semi_nurse
        license.semi_nurse_pt = semi_nurse_pt
        license.physical_therapist = physical_therapist
        license.physical_therapist_pt = physical_therapist_pt
        license.work_therapist = work_therapist
        license.work_therapist_pt = work_therapist_pt
        license.speech_therapist = speech_therapist 
        license.speech_therapist_pt = speech_therapist_pt
        license.social_worker = social_worker 
        license.social_worker_pt = social_worker_pt 
        license.care_worker = care_worker 
        license.care_worker_pt = care_worker_pt 
        license.strategist_training = strategist_training 
        license.strategist_training_pt = strategist_training_pt 
        license.staff_ground_training = staff_ground_training 
        license.staff_ground_training_pt = staff_ground_training_pt 
        license.orthoptist = orthoptist 
        license.orthoptist_pt = orthoptist_pt 
        license.prosthetist = prosthetist 
        license.prosthetist_pt = prosthetist_pt 
        license.dental_hygienist = dental_hygienist 
        license.dental_hygienist_pt = dental_hygienist_pt 
        license.acupressure_therapist = acupressure_therapist 
        license.acupressure_therapist_pt = acupressure_therapist_pt 
        license.acupuncture_therapist = acupuncture_therapist 
        license.acupuncture_therapist_pt = acupuncture_therapist_pt 
        license.moxacautery_therapist = moxacautery_therapist 
        license.moxacautery_therapist_pt = moxacautery_therapist_pt 
        license.judo_therapist = judo_therapist 
        license.judo_therapist_pt = judo_therapist_pt 
        license.dietician = dietician 
        license.dietician_pt = dietician_pt 
        license.managerial_dietician = managerial_dietician 
        license.managerial_dietician_pt = managerial_dietician_pt 
        license.psychiatric_social_worker = psychiatric_social_worker 
        license.psychiatric_social_worker_pt = psychiatric_social_worker_pt 
        license.save!
  
        RelKyotakuCareAddFeeStaff.delete_all(:office_id => kyotaku.office_id)
        RelKyotakuCareAddFeeStaff.create!(:office_id => kyotaku.office_id, :attr_id => 0) if add_fee_staff1 == "1"
        RelKyotakuCareAddFeeStaff.create!(:office_id => kyotaku.office_id, :attr_id => 1) if add_fee_staff2 == "1"

        RelKyotakuCareAddFeeService.delete_all(:office_id => kyotaku.office_id)
        RelKyotakuCareAddFeeService.create!(:office_id => kyotaku.office_id, :attr_id => 0) if add_fee1 == "1"
        RelKyotakuCareAddFeeService.create!(:office_id => kyotaku.office_id, :attr_id => 1) if add_fee2 == "1"
        RelKyotakuCareAddFeeService.create!(:office_id => kyotaku.office_id, :attr_id => 2) if add_fee3 == "1"
        RelKyotakuCareAddFeeService.create!(:office_id => kyotaku.office_id, :attr_id => 3) if add_fee4 == "1"
        RelKyotakuCareAddFeeService.create!(:office_id => kyotaku.office_id, :attr_id => 4) if add_fee5 == "1"
        RelKyotakuCareAddFeeService.create!(:office_id => kyotaku.office_id, :attr_id => 5) if add_fee6 == "1"

        RelKyotakuCareAddFeeOther.delete_all(:office_id => kyotaku.office_id)
        RelKyotakuCareAddFeeOther.create!(:office_id => kyotaku.office_id, :attr_id => 0) if add_fee_other1 == "1"
        RelKyotakuCareAddFeeOther.create!(:office_id => kyotaku.office_id, :attr_id => 1) if add_fee_other2 == "1"

        KyotakuHistory.create(
          :office_id => kyotaku.office_id,
          :editor => "toriumi csv to db",
          :action => "UPDATE"
        )
      }
    }
#    raise "dry run"
  }
end

main
