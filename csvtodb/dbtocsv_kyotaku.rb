
require 'active_record'
load 'lib/connection.rb'
load 'lib/tables.rb'

def write_line(out, warn, row, s_areas)
  kyotaku_no = row[1]
  puts kyotaku_no

  kyotaku = Kyotaku.where(:office_no => kyotaku_no).first
  if kyotaku.nil? then
    puts "kytoaku not found: office_no=%d" % kyotaku_no
    warn.puts "kytoaku not found: office_no=%d" % kyotaku_no
    return
  end
  office_id = kyotaku.office_id

  line = [
    kyotaku.name,
    kyotaku.office_no,
    kyotaku.company,
    kyotaku.tell]

  line << if RelKyotakuTellEmergency.where(:office_id => office_id).first.nil? then 0 else 1 end

  line << kyotaku.tell_emergency
  line << kyotaku.fax
  line << kyotaku.address
  line << kyotaku.latitude
  line << kyotaku.longitude
  line << kyotaku.hp_address
  line << kyotaku.delegate
  line << kyotaku.founding_day

  service_area = RelKyotakuServiceArea.where(:office_id => office_id).all.map {|s|
    s_areas.select {|sa| sa.id == s.attr_id}.first.name
  }
  line << service_area * "\n"

  line << kyotaku.service_area_biko

  business_times = KyotakuBusinessTime.where(:office_id => office_id).all.map {|a|
    [a.day_id, {:day_id => a.day_id, :from_date => a.from_date_hm, :to_date => a.to_date_hm}]
  }
  business_times = Hash[business_times]
  business_times.default = {}
  line << business_times[0][:from_date]
  line << business_times[0][:to_date]
  line << business_times[5][:from_date]
  line << business_times[5][:to_date]
  line << business_times[6][:from_date]
  line << business_times[6][:to_date]
  line << business_times[7][:from_date]
  line << business_times[7][:to_date]

  line << kyotaku.long_vacation
  line << kyotaku.cm_cnt_rate.to_f
  line << kyotaku.cm_cnt
  line << kyotaku.cm_pt_cnt
  line << kyotaku.cm_cnt_chief
  line << kyotaku.cm_pt_cnt_chief
  line << kyotaku.cm_cnt_5year_career.to_f
  line << kyotaku.cm_cnt_male
  line << kyotaku.cm_cnt_female

  kyotaku_license = KyotakuLicense.where(:office_id => office_id).first
  line << kyotaku_license.doctor
  line << kyotaku_license.doctor_pt
  line << kyotaku_license.dentist
  line << kyotaku_license.dentist_pt
  line << kyotaku_license.dispenser
  line << kyotaku_license.dispenser_pt
  line << kyotaku_license.health_nurse
  line << kyotaku_license.health_nurse_pt
  line << kyotaku_license.midwife
  line << kyotaku_license.midwife_pt
  line << kyotaku_license.nurse
  line << kyotaku_license.nurse_pt
  line << kyotaku_license.semi_nurse
  line << kyotaku_license.semi_nurse_pt
  line << kyotaku_license.physical_therapist
  line << kyotaku_license.physical_therapist_pt
  line << kyotaku_license.work_therapist
  line << kyotaku_license.work_therapist_pt
  line << kyotaku_license.speech_therapist
  line << kyotaku_license.speech_therapist_pt
  line << kyotaku_license.social_worker
  line << kyotaku_license.social_worker_pt
  line << kyotaku_license.care_worker
  line << kyotaku_license.care_worker_pt
  line << kyotaku_license.strategist_training
  line << kyotaku_license.strategist_training_pt
  line << kyotaku_license.staff_ground_training
  line << kyotaku_license.staff_ground_training_pt
  line << kyotaku_license.orthoptist
  line << kyotaku_license.orthoptist_pt
  line << kyotaku_license.prosthetist
  line << kyotaku_license.prosthetist_pt
  line << kyotaku_license.dental_hygienist
  line << kyotaku_license.dental_hygienist_pt
  line << kyotaku_license.acupressure_therapist
  line << kyotaku_license.acupressure_therapist_pt
  line << kyotaku_license.acupuncture_therapist
  line << kyotaku_license.acupuncture_therapist_pt
  line << kyotaku_license.moxacautery_therapist
  line << kyotaku_license.moxacautery_therapist_pt
  line << kyotaku_license.judo_therapist
  line << kyotaku_license.judo_therapist_pt
  line << kyotaku_license.dietician
  line << kyotaku_license.dietician_pt
  line << kyotaku_license.managerial_dietician
  line << kyotaku_license.managerial_dietician_pt
  line << kyotaku_license.psychiatric_social_worker
  line << kyotaku_license.psychiatric_social_worker_pt

  add_staff = RelKyotakuCareAddFeeStaff.where(:office_id => office_id).all.map {|a| a.attr_id}
  line << if add_staff.include?(0) then 1 else 0 end
  line << if add_staff.include?(1) then 1 else 0 end

  add_service = RelKyotakuCareAddFeeService.where(:office_id => office_id).all.map {|a| a.attr_id}
  line << if add_service.include?(0) then 1 else 0 end
  line << if add_service.include?(1) then 1 else 0 end
  line << if add_service.include?(2) then 1 else 0 end
  line << if add_service.include?(3) then 1 else 0 end
  line << if add_service.include?(4) then 1 else 0 end
  line << if add_service.include?(5) then 1 else 0 end

  add_other = RelKyotakuCareAddFeeOther.where(:office_id => office_id).all.map {|a| a.attr_id}
  line << if add_other.include?(0) then 1 else 0 end
  line << if add_other.include?(1) then 1 else 0 end
  out << line
end

def main
  input, output = if ARGV.length < 2 then
    puts "no input/output file."
    puts "Usage: #{$0} input.csv output.csv"
    exit
  else
    ARGV.shift 2
  end

  connect
  
  require 'csv'
  
  csv = CSV.read(input, encoding:"utf-8")
  header = csv.shift 1

  CSV.open(output, "wb") {|out|
    header.each do |h|
      out << h
    end

    service_areas = AttrKyotakuServiceArea.all 
    
    open("warn.csv", "w") {|warn|
      csv.each do |row|
        write_line(out, warn, row, service_areas)
      end
    }
  }
end

main
