require 'mongo'

connection = Mongo::Client.new(['127.0.0.1:27017'], :database => 'garden')
db = connection.database

puts 'connected!'