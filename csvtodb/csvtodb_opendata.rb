
require 'active_record'

load 'lib/connection.rb'

def usage
  puts "Usage: #{$0} input.csv [DAY|KYOTAKU]"
end

def main
  file, kind = if $*.length != 2 then
    puts "no input file."
    usage
    exit
  else
    [$*.shift, $*.shift]
  end
  
  if kind != "DAY" && kind != "KYOTAKU" then
    usage
    exit
  end
  
  connect
  
  require 'csv'
  load 'lib/tables.rb'
  
  csv = CSV.read(file, encoding:"utf-8")

  maxdayid = Office.maximum(:office_id)
  maxkyoid = Kyotaku.maximum(:office_id)
  if maxdayid.nil? || maxkyoid.nil? then
    puts "office table is empty."
    exit
  end

  transaction {
    open("warn.csv", "w") {|f|
      csv.each {|row|
        district,
        business_kind,
        office_no,
        name,
        address,
        tel,
        dummy1,
        dummy2,
        latitude,
        longitude = row
  
        if kind == "DAY" then
          office = Office.where(["office_no = ?", office_no]).first
          if office.nil? then
            maxdayid += 1
            office = Office.new(:office_id => maxdayid, :office_no => office_no)
          end
        elsif kind == "KYOTAKU" then
          office = Kyotaku.where(["office_no = ?", office_no]).first
          if office.nil? then
            maxkyoid += 1
            office = Kyotaku.new(:office_id => maxkyoid, :office_no => office_no)
          end
        end
        office.name = name
        office.address = address
        office.latitude = latitude
        office.longitude = longitude
        office.tel = tel if kind == "DAY"
        office.tell = tel if kind == "KYOTAKU"
        office.save!
  
        RelBusinessKind.delete_all(:office_id => office.office_id) if kind == "DAY"
        RelBusinessKind.create!(:office_id => office.office_id, :attr_id => 5) if kind == "DAY"
  
        OfficeHistory.create(
          :office_id => office.office_id,
          :editor => "toriumi opendata_csv to db",
          :action => "UPDATE"
        ) if kind == "DAY"
        KyotakuHistory.create(
          :office_id => office.office_id,
          :editor => "toriumi opendata_csv to db",
          :action => "UPDATE"
        ) if kind == "KYOTAKU"
      }
    }
#    raise "dry run"
  }
end

main
