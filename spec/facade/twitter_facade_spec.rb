require 'rails_helper'

describe TwitterFacade do
	before(:each) do
    	@factory_json = TweetsJsonFactory.new
    	@factory_obj = UserTweetsObjFactory.new
		@service_mock = double("ServiceMock")
		@twitter_facade = TwitterFacade.new(@service_mock)
  	end
	
  	describe "usuario_mencionado?" do

		it 'User mention in text!' do
			
			json = @factory_json.produce_tweets_json
			json["entities"]["user_mentions"][0]["id"] = 100

			usuario_mencionado = @twitter_facade.usuario_mencionado?(json, 100)

			expect(usuario_mencionado).to be true

		end

		it 'User NO mention in text!' do
			
			json = @factory_json.produce_tweets_json
			json["entities"]["user_mentions"][0]["id"] = 50

			usuario_mencionado = @twitter_facade.usuario_mencionado?(json, 100)

			expect(usuario_mencionado).to be false

		end

		it 'ArgumentError - Key entities does not exist' do

	    	json = @factory_json.produce_tweets_json
	    	json.delete('entities')

		    expect{@twitter_facade.usuario_mencionado?(json, 100)}.to raise_error(ArgumentError, /Error - key 'entities' does not exist/)

	  	end

	  	it 'ArgumentError - Key entities.user_mentions does not exist' do

	    	json = @factory_json.produce_tweets_json
	    	json['entities'].delete('user_mentions')

		    expect{@twitter_facade.usuario_mencionado?(json, 100)}.to raise_error(ArgumentError, /Error - key 'entities.user_mentions' does not exist/)

	  	end

		it 'ArgumentError - Key entities.user_mentions.id does not exist' do

			json = @factory_json.produce_tweets_json	
			json['entities']['user_mentions'][0].delete('id')

			expect{@twitter_facade.usuario_mencionado?(json, 100)}.to raise_error(ArgumentError, /Error - key 'entities.user_mentions.id' does not exist/)

		end

	end

	describe "json_valid?" do
		it 'JSON valid' do
			json = @factory_json.produce_body
			json_valid = @twitter_facade.json_valid?(json)

			expect(json_valid).to be true
		end

		it 'JSON invalid' do
			json = "JSON INVALID!"
			json_invalid = @twitter_facade.json_valid?(json)

			expect(json_invalid).to be false
		end

		it 'JSON nil' do
			json = nil
			json_nil = @twitter_facade.json_valid?(json)

			expect(json_nil).to be false
		end
	end

	describe "tweets_json" do
		it 'Parse body-response to JSON' do

			body = @factory_json.produce_body
			json_return = @twitter_facade.tweets_json(body)["statuses"]

			json_expect  = @factory_json.produce_all_tweets_json_array

			expect(json_return).to eq(json_expect)

		end

		it 'ArgumentError - body nil' do

			body = nil

			expect{@twitter_facade.tweets_json(body)}.to raise_error(ArgumentError, /JSON invalid/)

		end

		it 'ArgumentError - body invalid' do

			body = "It isn't json"

			expect{@twitter_facade.tweets_json(body)}.to raise_error(ArgumentError, /JSON invalid/)

		end
	end

	describe "parse_json_to_obj" do
		it 'Parse JSON to Object' do

			json = @factory_json.produce_tweets_json

			id_tweet = 123
	        retweet_count = 10
	        favorite_count = 0
	        text = "Hello Word"
	        created_a = "Mon Sep 24 03:35:21 +0000 2012"
	        screen_name = "ThiagoSoares"
	        id_user = 1
	        followers_count = 950

	        json['id'] = id_tweet
	        json['retweet_count'] = retweet_count
	        json['favorite_count'] = favorite_count
	        json['text'] = text
	        json['created_at'] = created_a
	        json['user']['screen_name'] = screen_name
	        json['user']['id'] = id_user
	        json['user']['followers_count'] = followers_count

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash[id_user] = json_array


	        params = Hash.new
        	params[:id] = id_tweet 
	        params[:user] = screen_name
	        params[:retweets] = retweet_count
	        params[:likes] = favorite_count
	        params[:text] = text
	        params[:date] = created_a
	        tweets = Array.new
	        tweets << Tweet.new(params)

	        u_params = Hash.new
            u_params[:id] = id_user
	        u_params[:name] = screen_name
	        u_params[:fallowers] = followers_count
	        u_params[:tweets] = tweets

	        user_esperado = User.new(u_params)

        	

	        user_retornado = @twitter_facade.parse_json_to_obj(json_hash)

			expect(user_retornado[0].id).to eq(user_esperado.id)
			expect(user_retornado[0].name).to eq(user_esperado.name)
			expect(user_retornado[0].fallowers).to eq(user_esperado.fallowers)
			expect(user_retornado[0].tweets[0].id).to eq(user_esperado.tweets[0].id)
			expect(user_retornado[0].tweets[0].user).to eq(user_esperado.tweets[0].user)
			expect(user_retornado[0].tweets[0].retweets).to eq(user_esperado.tweets[0].retweets)
			expect(user_retornado[0].tweets[0].likes).to eq(user_esperado.tweets[0].likes)
			expect(user_retornado[0].tweets[0].text).to eq(user_esperado.tweets[0].text)
			expect(user_retornado[0].tweets[0].date).to eq(user_esperado.tweets[0].date)

		end

		it 'Key id_tweet does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('id')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'id' does not exist/)
		end

		it 'Key retweet_count does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('retweet_count')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'retweet_count' does not exist/)
		end

		it 'Key user.favourites_count does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('favourites_count')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.favourites_count' does not exist/)
		end

		it 'Key text does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('text')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'text' does not exist/)
		end

		it 'Key created_at does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('created_at')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'created_at' does not exist/)
		end		

		it 'Key user.id does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('id')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.id' does not exist/)
		end	

		it 'Key user.screen_name does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('screen_name')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.screen_name' does not exist/)
		end	

		it 'Key user.fallowers_count does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('followers_count')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array
			
	        expect{@twitter_facade.parse_json_to_obj(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.fallowers_count' does not exist/)
		end	

	end

	describe "filter_by_user_mention" do
		
		it 'Key user.in_reply_to_user_id does not exist' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array
			json[0].delete("in_reply_to_user_id")

	        expect{@twitter_facade.filter_by_user_mention(json, id_locaweb)}.to raise_error(ArgumentError, /Error - key 'in_reply_to_user_id' does not exist/)
		end

		it 'Key user does not exist' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array
			json[0].delete("user")
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb

	        expect{@twitter_facade.filter_by_user_mention(json, id_locaweb)}.to raise_error(ArgumentError, /Key 'user' does not exist/)
		end
	
		it 'Key id_str does not exist' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array
			json[0]['user'].delete("id_str")
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb

	        expect{@twitter_facade.filter_by_user_mention(json, id_locaweb)}.to raise_error(ArgumentError, /Key 'user.id_str' does not exist/)
		end	

		it 'Filter tweets by user_mention - locaweb(42) and dont reply' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[0]["in_reply_to_user_id"] = 10 


	        json_esperado = Hash.new
	        json_array = Array.new
	        json_array << json[0]
			json_esperado[json[0]['user']['id_str']] = json_array
			
			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Dont have tweets with user mention' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[0]["in_reply_to_user_id"] = 42 

			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

			json_esperado = Hash.new

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention but it is replay' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = 75
			json[0]["in_reply_to_user_id"] = 42 

			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

			json_esperado = Hash.new

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Dont have tweets with user mention and dont replay' do
			id_locaweb = 42
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = 75
			json[0]["in_reply_to_user_id"] = 10

			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

			json_esperado = Hash.new

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention - locaweb(42) and dont reply - TWO tweets' do
			id_locaweb = 42
			id_user = 700

			json = @factory_json.produce_tweets_json_array(2)
			json[0]["user"]["id_str"] = id_user
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[0]["in_reply_to_user_id"] = 10

			json[1]["user"]["id_str"] = id_user
			json[1]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[1]["in_reply_to_user_id"] = 15 


	        json_esperado = Hash.new
	        json_array = Array.new
	        json_array << json[0]
	        json_array << json[1]

			json_esperado[id_user] = json_array
			
			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention - locaweb(42) and dont reply - Two tweets same user' do
			id_locaweb = 42
			id_user = 700
			id_other_user_1 = 10
			id_other_user_2 = 30

			json = @factory_json.produce_tweets_json_array(4)

			json[0]["user"]["id_str"] = id_user
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[0]["in_reply_to_user_id"] = 10

			json[1]["user"]["id_str"] = id_user
			json[1]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[1]["in_reply_to_user_id"] = 15 

			json[2]["user"]["id_str"] = id_other_user_1
			json[2]["in_reply_to_user_id"] = 150

			json[3]["user"]["id_str"] = id_other_user_2
			json[3]["entities"]["user_mentions"][0]["id"] = 31
			json[3]["in_reply_to_user_id"] = 90 

	        json_esperado = Hash.new
	        json_array_1 = Array.new
	        json_array_1 << json[0]
	        json_array_1 << json[1]

			json_esperado[id_user] = json_array_1

			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention - locaweb(42) and dont reply - Two tweets same user and one tweet other user' do
			id_locaweb = 42
			id_user = 700
			id_other_user_1 = 10
			id_other_user_2 = 30

			json = @factory_json.produce_tweets_json_array(4)

			json[0]["user"]["id_str"] = id_user
			json[0]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[0]["in_reply_to_user_id"] = 10

			json[1]["user"]["id_str"] = id_user
			json[1]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[1]["in_reply_to_user_id"] = 15 

			json[2]["user"]["id_str"] = id_other_user_1
			json[2]["in_reply_to_user_id"] = 150

			json[3]["user"]["id_str"] = id_other_user_2
			json[3]["entities"]["user_mentions"][0]["id"] = id_locaweb
			json[3]["in_reply_to_user_id"] = 90 

	        json_esperado = Hash.new
	        json_array_1 = Array.new
	        json_array_1 << json[0]
	        json_array_1 << json[1]

	        json_array_2 = Array.new
	        json_array_2 << json[3]

			json_esperado[id_user] = json_array_1
			json_esperado[id_other_user_2] = json_array_2

			json_retornado = @twitter_facade.filter_by_user_mention(json, id_locaweb)

	        expect(json_retornado).to eq (json_esperado)
		end	
	end

	
	describe "order_tweets" do
		it 'Key retweet_count does not exist' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash

			json = json_hash.values[0][0]
			json.delete("retweet_count")

	        expect{@twitter_facade.order_tweets(json_hash)}.to raise_error(ArgumentError, /Key 'retweet_count' does not exist/)
		end

		it 'Key user does not exist' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash

			json = json_hash.values[0][0]
			json.delete("user")

	        expect{@twitter_facade.order_tweets(json_hash)}.to raise_error(ArgumentError, /Key 'user' does not exist/)
		end

		it 'Key user.favourites_count does not exist' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash

			json = json_hash.values[0][0]
			user_json = json['user']
			user_json.delete("favourites_count")

	        expect{@twitter_facade.order_tweets(json_hash)}.to raise_error(ArgumentError, /Key 'user.favourites_count' does not exist/)
		end

		it 'Key user.followers_count does not exist' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash

			json = json_hash.values[0][0]
			user_json = json['user']
			user_json.delete("followers_count")

	        expect{@twitter_facade.order_tweets(json_hash)}.to raise_error(ArgumentError, /Key 'user.followers_count' does not exist/)
		end

		it 'Order only one tweet' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(1)

			array_user_tweets = Array.new
			array_user_tweets << json_hash.keys[0]
			array_user_tweets << json_hash.values[0]

			json_esperado = Array.new
			json_esperado << array_user_tweets

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 2 tweets' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(2)


			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 800
			array_user_tweets_1 << tweets_user_1

			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 900
			array_user_tweets_2 << json_hash.values[1]

			json_esperado = Array.new
			json_esperado << array_user_tweets_2
			json_esperado << array_user_tweets_1

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 3 tweets' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 600
			array_user_tweets_1 << tweets_user_1


			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 500
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 700
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_3
			json_esperado << array_user_tweets_1
			json_esperado << array_user_tweets_2

			json_retornado = @twitter_facade.order_tweets(json_hash)

	        expect(json_retornado).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 3 tweets' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 500
			array_user_tweets_1 << tweets_user_1


			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 600
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 700
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_3
			json_esperado << array_user_tweets_2
			json_esperado << array_user_tweets_1

			json_retornado = @twitter_facade.order_tweets(json_hash)

	        expect(json_retornado).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 3 tweets' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 700
			array_user_tweets_1 << tweets_user_1


			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 600
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 500
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_1
			json_esperado << array_user_tweets_2
			json_esperado << array_user_tweets_3

			json_retornado = @twitter_facade.order_tweets(json_hash)

	        expect(json_retornado).to eq (json_esperado)
		end
		it 'Order tweets by retweet_count - user.followers_count equals - I' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 800
			tweets_user_1[0]['retweet_count'] = 50
			array_user_tweets_1 << tweets_user_1

			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 800
			tweets_user_2[0]['retweet_count'] = 70
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 800
			tweets_user_3[0]['retweet_count'] = 10
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_2
			json_esperado << array_user_tweets_1
			json_esperado << array_user_tweets_3

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end

		it 'Order tweets by retweet_count - user.followers_count equals - II' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 900
			tweets_user_1[0]['retweet_count'] = 50
			array_user_tweets_1 << tweets_user_1

			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 800
			tweets_user_2[0]['retweet_count'] = 70
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 800
			tweets_user_3[0]['retweet_count'] = 80
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_1
			json_esperado << array_user_tweets_3
			json_esperado << array_user_tweets_2

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end

		it 'Order tweets by user.favourites_count - user.followers_count and retweet_count are equals - I' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 900
			tweets_user_1[0]['retweet_count'] = 50
			tweets_user_1[0]['user']['favourites_count'] = 500
			array_user_tweets_1 << tweets_user_1

			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 900
			tweets_user_2[0]['retweet_count'] = 50
			tweets_user_2[0]['user']['favourites_count'] = 600
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 900
			tweets_user_3[0]['retweet_count'] = 50
			tweets_user_3[0]['user']['favourites_count'] = 700
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_3
			json_esperado << array_user_tweets_2
			json_esperado << array_user_tweets_1

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end

		it 'Order tweets by user.favourites_count - user.followers_count and retweet_count are equals - II' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 900
			tweets_user_1[0]['retweet_count'] = 50
			tweets_user_1[0]['user']['favourites_count'] = 700
			array_user_tweets_1 << tweets_user_1

			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 900
			tweets_user_2[0]['retweet_count'] = 50
			tweets_user_2[0]['user']['favourites_count'] = 450
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 900
			tweets_user_3[0]['retweet_count'] = 50
			tweets_user_3[0]['user']['favourites_count'] = 500
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_1
			json_esperado << array_user_tweets_3
			json_esperado << array_user_tweets_2

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end

		it 'Order tweets by user.favourites_count - user.followers_count and retweet_count are equals - III' do
			id_locaweb = 42
			json_hash = @factory_json.produce_tweets_json_hash(3)

			array_user_tweets_1 = Array.new
			array_user_tweets_1 << json_hash.keys[0]
			tweets_user_1 = json_hash.values[0]
			tweets_user_1[0]['user']['followers_count'] = 900
			tweets_user_1[0]['retweet_count'] = 50
			tweets_user_1[0]['user']['favourites_count'] = 700
			array_user_tweets_1 << tweets_user_1

			array_user_tweets_2 = Array.new
			array_user_tweets_2 << json_hash.keys[1]
			tweets_user_2 = json_hash.values[1]
			tweets_user_2[0]['user']['followers_count'] = 900
			tweets_user_2[0]['retweet_count'] = 50
			tweets_user_2[0]['user']['favourites_count'] = 450
			array_user_tweets_2 << json_hash.values[1]

			array_user_tweets_3 = Array.new
			array_user_tweets_3 << json_hash.keys[2]
			tweets_user_3 = json_hash.values[2]
			tweets_user_3[0]['user']['followers_count'] = 900
			tweets_user_3[0]['retweet_count'] = 50
			tweets_user_3[0]['user']['favourites_count'] = 500
			array_user_tweets_3 << json_hash.values[2]

			json_esperado = Array.new
			json_esperado << array_user_tweets_1
			json_esperado << array_user_tweets_3
			json_esperado << array_user_tweets_2

	        expect(@twitter_facade.order_tweets(json_hash)).to eq (json_esperado)
		end
	end
	describe "tweets" do
		it 'Tweets - Test all cycle' do
			body = @factory_json.produce_body_locaweb

			allow(@service_mock).to receive(:call_service).and_return(body)
			id_locaweb = 42

			user_retornado = @twitter_facade.tweets(id_locaweb)

			id_tweet = 728722
	        retweet_count = 6
	        favorite_count = 0
	        text = "@locaweb transmitting the hard drive won't do anything, we need to compress "
	        created_a = "Mon Sep 24 03:35:21 +0000 2012"
	        screen_name = "mrs_mertz_kaelyn"
	        id_user = 213001
	        followers_count = 129

	        params = Hash.new
        	params[:id] = id_tweet 
	        params[:user] = screen_name
	        params[:retweets] = retweet_count
	        params[:likes] = favorite_count
	        params[:text] = text
	        params[:date] = created_a
	        tweets = Array.new
	        tweets << Tweet.new(params)

	        u_params = Hash.new
            u_params[:id] = id_user
	        u_params[:name] = screen_name
	        u_params[:fallowers] = followers_count
	        u_params[:tweets] = tweets

	        user_esperado = User.new(u_params)

			expect(user_retornado[0].id).to eq(user_esperado.id)
			expect(user_retornado[0].name).to eq(user_esperado.name)
			expect(user_retornado[0].fallowers).to eq(user_esperado.fallowers)
			expect(user_retornado[0].tweets[0].id).to eq(user_esperado.tweets[0].id)
			expect(user_retornado[0].tweets[0].user).to eq(user_esperado.tweets[0].user)
			expect(user_retornado[0].tweets[0].retweets).to eq(user_esperado.tweets[0].retweets)
			expect(user_retornado[0].tweets[0].likes).to eq(user_esperado.tweets[0].likes)
			expect(user_retornado[0].tweets[0].text).to eq(user_esperado.tweets[0].text)
			expect(user_retornado[0].tweets[0].date).to eq(user_esperado.tweets[0].date)
			
		end

		it 'Tweets - body is nil' do
			body = nil

			allow(@service_mock).to receive(:call_service).and_return(body)
			

			user_retornado = @twitter_facade.tweets(42)

			expect(user_retornado).to be false
			
		end
	end
end

# allow(@service_mock).to receive(:chamar_servico).and_return(json)
