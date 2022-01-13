//1. Singer collection의 singer3에 albums에 10을 push 하시오.
db.Singer.update( {name:'singer3'}, 
				 { 
					$addToSet: { albums: {$each: [10]} } 
				 }
)
                
db.Singer.findOne( {name:'singer3'})


//2. singer4의 albums에 100 ~ 110 까지 $each를 사용하여 push하시오.
for (let i=100; i <= 110; i++){
    db.Singer.update( {name:'singer4'}, 
    				 {  
    					$addToSet: { albums: {$each: [i]} } 
    				 }
                    )
}

//3. singer4의 albums에 105번을 제거하시오
db.Singer.update( {name:'singer4'}, 
				 { 
					$pull: { albums: 105 } 
				 }
)

//4. singer4의 albums에 103번 이하($lte)를 제거하시오.
db.Singer.update({name: 'singer4'}, {$pull: {albums: { $lte: 103 }  }})

//5. singer4의 albums에 [107, 109]를 제거하시오.
db.Singer.update({name: 'singer4'}, {$pull: {albums: { $in: [107,109] }  }})

db.Singer.findOne( {name:'singer4'})



