// 1. 아래와 같이 100개의 가수(Singer) 문서를 만드시오.

for (let i=1; i <= 100; i++) {
		db.Singer.insert({name:'singer' + i, company: 'com' + i, likecnt: '1'})
}
	

// 2. singer1의 문서에 albums 키를 추가하시오.
var meet = db.Singer.findOne({name: 'singer1'})

meet.albums = [1, 2, 3]

db.Singer.save(meet) 

// 3. singer1의 문서에 아래 노래(hitsongs) 2곡을 추가하시오.
db.Singer.update(
                    {name: 'singer1'}, 
                    {
                        $set:
                            {hitsongs: [
                                        {title: '24/7', albumId: 1},
                                        {title: '222', albumId: 2}
                                       ]
                            }
                    }
)
        
// 4. singer1의 likecnt를 제거하시오.

db.Singer.update({name: 'singer1'}, 
                {$unset:{likecnt: 1}})
                
db.Singer.findOne()

