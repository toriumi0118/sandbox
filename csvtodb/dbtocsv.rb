
require 'active_record'
load 'lib/connection.rb'
load 'lib/tables.rb'

def write_line(out, row, business_kinds, contracts)
  office_no = row[0]
  puts office_no

  office = Office.where(:office_no => office_no).first
  if office.nil? then
    puts "office not found: office_no=%d" % office_no
    exit
  end
  office_id = office.office_id

  if contracts.include? office_id then
    out << row
    return
  end

  line = [
    office.office_no,
    office.name,
    office.company,
    office.address,
    office.latitude,
    office.longitude,
    office.tel,
    office.fax]

  line << if RelHelpLevel.where(:office_id => office_id).first.nil? then 0 else 1 end

  line << Vacancy.where(:office_id => office_id, :day_id => 0, :term_ord => 0).first.capacity_cnt

  line << if RelExtra.where(:office_id => office_id).first.nil? then 0 else 1 end

  add_fees = RelAddFee.where(:office_id => office_id).all.map {|a| a.attr_id}
  line << if add_fees.include?(11) then 1 else 0 end
  line << if add_fees.include?(12) then 1 else 0 end
  line << if add_fees.include?(13) then 1 else 0 end
  line << if add_fees.include?(5) then 1 else 0 end
  line << if add_fees.include?(6) then 1 else 0 end
  line << if add_fees.include?(4) then 1 else 0 end
  line << if add_fees.include?(7) then 1 else 0 end
  line << if add_fees.include?(8) then 1 else 0 end
  line << if add_fees.include?(9) then 1 else 0 end

  add_fee_workers = RelAddFeeWorker.where(:office_id => office_id).all.map {|a| a.attr_id}
  line << if add_fee_workers.include?(0) then 1 else 0 end
  line << if add_fee_workers.include?(1) then 1 else 0 end
  line << if add_fee_workers.include?(2) then 1 else 0 end

  office_price = OfficePrice.where(:office_id => office_id).first
  line << office_price.meal_biko
  line << office_price.morning
  line << office_price.launch
  line << office_price.dinner
  line << office_price.snack

  office_license = OfficeLicence.where(:office_id => office_id).first
  line << office_license.nurse
  line << office_license.pt_nurse

  line << office.staff_cnt

  kinds = RelBusinessKind.where(:office_id => office_id).all.map {|k|
    business_kinds.select {|ks| ks.id == k.attr_id }.first.name
  }
  line << kinds * "\n"

  business_times = BusinessTime.where(:office_id => office_id).all.map {|a|
    [a.day_id, {:day_id => a.day_id, :from_date => a.from_date_hm, :to_date => a.to_date_hm}]
  }.to_h
  business_times.default = {}
  line << business_times["0"][:from_date]
  line << business_times["0"][:to_date]
  line << business_times["5"][:from_date]
  line << business_times["5"][:to_date]
  line << business_times["6"][:from_date]
  line << business_times["6"][:to_date]
  line << business_times["7"][:from_date]
  line << business_times["7"][:to_date]

  line << office.drive_range_biko
  line << office.founding_day

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
  header = csv.shift 3

  contracts = OfficeContract.all.map {|o| o.office_id }
  business_kinds = AttrBusinessKind.all

  CSV.open(output, "wb") {|out|
    header.each do |h|
      puts h
      out << h
    end

    csv.each do |row|
      write_line(out, row, business_kinds, contracts)
    end
  }
end

main
