require 'rubygems'
require 'mongo'
include Mongo

$client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'garden')
fs = $client.database.fs

file = Mongo::Grid::File.new('I am a NEW file', :filename => 'aFile.txt')
$client.database.fs.insert_one(file)

$fileObj = $client.database.fs.find_one(:filename => 'aFile.txt')
$file_id = $fileObj.id

$file_to_write = File.open('perfectCopy', 'w')
fs.download_to_stream($file_id, $file_to_write)
