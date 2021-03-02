# require 'rubygems'
# require 'mongo'
# $con   = Mongo::Connection.new
# $db    = $con['tutorial']
# $users = $db['users']
# puts 'connected!'
require 'rubygems'
require 'mongo'

$client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'tutorial')
Mongo::Logger.logger.level = ::Logger::ERROR

$users = $client[:users]
puts 'connected!'