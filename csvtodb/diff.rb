
require 'csv'

load 'lib/connection.rb'
load 'lib/tables.rb'

def diff(row1, row2)
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
    founding_day = row1.zip(row2)

  cmp(office_no) ||
  cmp(office_name) ||
  cmp(company) ||
  cmp(address) ||
  cmp(latitude) ||
  cmp(longitude) ||
  cmp(tel) ||
  cmp(fax) ||
  cmp(help_level) ||
  cmp(vacancy) ||
  cmp(extra) ||
  cmp(add_fee1) ||
  cmp(add_fee2) ||
  cmp(add_fee3) ||
  cmp(add_fee4) ||
  cmp(add_fee5) ||
  cmp(add_fee6) ||
  cmp(add_fee7) ||
  cmp(add_fee8) ||
  cmp(add_fee9) ||
  cmp(add_fee_worker1) ||
  cmp(add_fee_worker2) ||
  cmp(add_fee_worker3) ||
  cmp(meal_biko) ||
  cmp(morinig) ||
  cmp(launch) ||
  cmp(dinner) ||
  cmp_n(nurse) ||
  cmp_n(pt_nurse) ||
  cmp_n(staff_cnt) ||
  business_kind_cmp(business_kind) ||
  cmp(bt0_from) ||
  cmp(bt0_to) ||
  cmp(bt5_from) ||
  cmp(bt5_to) ||
  cmp(bt6_from) ||
  cmp(bt6_to) ||
  cmp(bt7_from) ||
  cmp(bt7_to) ||
  cmp(drive_range_biko) ||
  cmp(founding_day)
end

def cmp(rows)
  ! (rows[0].nil? ? (rows[1].nil? || rows[1] == "0") : rows[0] == rows[1])
end

def cmp_n(rows)
  ! (rows[0].nil? ? (rows[1].nil? || rows[1] == "0") : rows[0].to_f.ceil == rows[1].to_i)
end

def business_kind_cmp(kinds)
  ks = kinds[0].nil? ? [] : kinds[0].split(/\R/)
  ! kinds[1].split(/\R/).reduce(true) {|r,k| r && ks.include?(k) }
end

def main
  file1, file2 = if ARGV.length < 2 then
    puts "no input files."
    puts "Usage: #{$0} file1.csv file2.csv"
    exit
  else
    ARGV.shift 2
  end

  connect

  contracts = OfficeContract.all.map {|o|
    Office.find(o.office_id).office_no
  }

  data1 = CSV.read(file1)
  data2 = CSV.read(file2)

  zip = data1.zip(data2)
  zip.shift 3
  zip.each do |row1, row2|
    next if contracts.include? row1[0]
    if diff(row1, row2) then
      puts "*** diff ***"
      puts "- %s" % row1.to_s
      puts "+ %s" % row2.to_s
    end
  end
end

main
