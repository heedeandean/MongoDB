require 'rubygems'
require 'mongo'
require 'names'

@con = Mongo::MongoClient.new('localhost', 40000)
@col = @con['cloud-docs']['spreadsheets']
@data = 'abcde' * 1000

def write_user_docs(iterations=0, name_count=200)
	iterations.times do |iteration|
		name_count.times do |name_number|
			docs = { :filename => 'sheet=#{iteration}',
				 :updated_at => Time.now.utc, 
				 :username => Names::LIST[name_number],
				 :data => @data
			       }
			@col.insert(doc)
		end
	end
end

if ARGV.empty? || !(ARGV[0] =~ /^\d+$/)
	puts 'Usage: load.rb [iterations] [name_count]'
else
	iterations = ARGV[0].to_i
	if ARGV[1] && ARGV[1] =~ /^\d+$/
		name_count = ARGV[1].to_i
	else
		name_count = 200
	end
	write_user_docs(iterations, name_count)
end
