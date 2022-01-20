# GridFS : 대용량 이진데이터 저장 용이, 빠름
require 'rubygems'
require 'mongo'

include Mongo
$client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'images')
fs = $client.database.fs
$file = File.open('a.jpg')
$file_id = fs.upload_from_stream('a.jpg', $file)
$file.close

