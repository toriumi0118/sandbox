
if ARGV.length < 2 then
  puts "Usage: %s [123] inputfile" % $0
  exit
end

mode = ARGV.shift
file = ARGV.shift

result = Hash.new 0
def result.countup(key)
  self[key] = self[key] + 1
end

split = case mode
when "1"
  proc {|line| line.split /[^a-zA-Z]+/ }
when "2"
  proc {|line| line.chars.select {|c| c =~ /[a-zA-Z]/ } }
when "3"
  proc {|line| line.split(/[^a-zA-Z]+/).select {|s| !s.empty?}.map {|s| s[0] } }
else
  puts "unknown mode=%s" % mode
  exit
end

open(file, "r") {|f|
  begin
    while true do
      line = f.readline
      next if line.empty?

      ts = split.call line
      ts.each do |t|
        t.downcase!
        result.countup(t)
      end
    end
  rescue EOFError
  end
}

result.sort {|a, b| b[1] <=> a[1]}.each {|l| print l,$/}
