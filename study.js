db.Song.insert({title:'노래1', likecnt:1})

db.Song.update({title:'노래1'}, {$inc: {likecnt: 10}})

db.Song.find()

