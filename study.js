// DB(tutorial) 
use tutorial

// collection(users)
db.users.insert({ username: "smith" })

db.users.find()

db.users.count()

// AND
// 1.
db.users.find({ "_id": ObjectId("60326cf49c5df34bfacdd452"), "username": "j" })
// 2.
db.users.find({ $and: [{ "_id": ObjectId("60326cf49c5df34bfacdd452") }, { "username": "j" }] })


db.users.find({
    $or: [
        { "username": "j" }, { "username": "smith" }
    ]
})