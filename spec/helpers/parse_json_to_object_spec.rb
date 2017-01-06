require 'rails_helper'

describe ParseJsonToObject do
	before(:each) do
    	@factory_json = TweetsJsonFactory.new
		@parse_json_to_object = ParseJsonToObject.new
  	end

	describe "ParseJsonToObject" do
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

        	

	        user_retornado = @parse_json_to_object.parse(json_hash)

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

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'id' does not exist/)
		end

		it 'Key retweet_count does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('retweet_count')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'retweet_count' does not exist/)
		end

		it 'Key user.favourites_count does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('favourites_count')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.favourites_count' does not exist/)
		end

		it 'Key text does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('text')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'text' does not exist/)
		end

		it 'Key created_at does not exist' do

			json = @factory_json.produce_tweets_json
			json.delete('created_at')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'created_at' does not exist/)
		end		

		it 'Key user.id does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('id')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.id' does not exist/)
		end	

		it 'Key user.screen_name does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('screen_name')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array

	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.screen_name' does not exist/)
		end	

		it 'Key user.fallowers_count does not exist' do

			json = @factory_json.produce_tweets_json
			json['user'].delete('followers_count')

	        json_hash = Hash.new
	        json_array = Array.new
	        json_array << json
	        json_hash["1"] = json_array
			
	        expect{@parse_json_to_object.parse(json_hash)}.to raise_error(ArgumentError, /Error - key 'user.fallowers_count' does not exist/)
		end	

	end
end