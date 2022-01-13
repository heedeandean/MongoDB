show dbs
show collections
show tables

// DB(tutorial) 
use tutorial

// collection(users)
db.users.insert({ username: "smith" })
db.users.find().pretty()
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

db.users.update({ "username": "smith" }, { $set: { country: "Canada" } })
db.users.update({ "username": "smith" }, { country: "Canada" })
db.users.update({ "username": "smith" }, { $unset: { country: 1 } })

db.users.update({ "username": "smith" }, {
    $set:
    {
        favorites: {
            cities: ["Chicago", "Cheyenne"],
            movies: ["C", "F", "T"]
        }
    }
})

db.users.find({ "favorites.movies": "C" })

db.users.update({ "favorites.movies": "C" }
    , { $addToSet: { "favorites.movies": "M" } } // $addToSet(중복X) (cf. $push(중복O))
    , false
    , true // 다중업데이트 여부
)

db.users.remove({}) // 모든 도큐먼트 삭제 (like SQL DELETE)
db.users.remove({ "favorites.cities": "Cheyenne" })
db.users.drop() // 컬렉션 삭제


for (i = 0; i < 20000; i++) {
    db.numbers.save({ num: i });
}

// $gt(>), $gte(>=), $lt(<), $lt(<=), $ne(!=) 
db.numbers.find({ num: { "$gt": 19995 } }) // 19996~
db.numbers.find({ num: { "$gt": 20, "$lt": 25 } }) // 21~24


db.numbers.find({ num: { "$gt": 19995 } }).explain("executionStats")
db.numbers.createIndex({ num: 1 })

// 인덱스 확인
// 1.
db.numbers.getIndexes()
// 2.
db.numbers.runCommand({ "listIndexes": "numbers" })

db.stats() // = db.runCommand({ dbstats: 1 })
db.numbers.stats() // = db.runCommand({ collstats: "numbers" })