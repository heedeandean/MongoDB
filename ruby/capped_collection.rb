# 사용자 행위를 캡드 컬렉션에 기록
# * 캡드 컬렉션 : 고정된 크기 / 더 이상 공간이 없으면 가장 오래된 도큐먼트를 덮어씀 
require 'mongo'

VIEW_PRODUCT = 0
ADD_TO_CART = 1
CHECKOUT = 2
PURCHASE = 3

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'garden')

# garden.user_actions 컬렉션
client[:user_actions].drop
actions = client[:user_actions, :capped => true, :size => 16384] # 16KB
actions.create

# 500회 반복
500.times do |n|
	doc = {
		:username => 'hee',
		:action_code => rand(4), # 임의 정수(0~3)
		:time => Time.now.utc,
		:n => n # 1씩 증가
	}
	actions.insert_one(doc)
end

