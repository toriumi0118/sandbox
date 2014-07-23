
require 'active_record'

def connect
  require 'yaml'
  ActiveRecord::Base.establish_connection(
    YAML.load_file('database.yml')
  )
end

def transaction(&block)
  ActiveRecord::Base.transaction do
    block.call
  end
  puts "Complete!"
  rescue => e
  puts "Error: %s" % e.to_s
  e.backtrace.each do |t|
    puts t
  end
end
