require 'rubygems'
require 'mongo'

image_filename = File.join(File.dirname(__FILE__), 'a.jpg')
image_data = File.open(image_filename).read
bson_image_data = BSON::Binary.new(image_data)

doc = {'name' => 'b.jpg',
       'data' => bson_image_data}
@con = Mongo::Client.new(['localhost:27017'], :database => 'images')
@thumbnails = @con[:thumbnails]
result = @thumbnails.insert_one(doc)

@thumbnails.find({'name' => 'b.jpg'}).each do |doc|
	if image_data == doc['data'].to_s
		puts 'Stored image is equal to the original file!'
	end
end
