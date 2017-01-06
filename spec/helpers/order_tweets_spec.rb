require 'rails_helper'

describe OrderTweets do
	ID_LOCAWEB = 42

	before(:each) do
    	@factory_json = TweetsJsonFactory.new
		@order = OrderTweets.new
  	end

	describe "order_tweets" do
		it 'Key retweet_count does not exist' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0].delete("retweet_count")

	        expect{@order.execute(json)}.to raise_error(ArgumentError, /Key 'retweet_count' does not exist/)
		end

		it 'Key user does not exist' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0].delete("user")

	        expect{@order.execute(json)}.to raise_error(ArgumentError, /Key 'user' does not exist/)
		end

		it 'Key user.favourites_count does not exist' do

			json = @factory_json.produce_tweets_json_array(1)
			json[0]['user'].delete("favourites_count")

	        expect{@order.execute(json)}.to raise_error(ArgumentError, /Key 'user.favourites_count' does not exist/)
		end

		it 'Key user.followers_count does not exist' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0]['user'].delete("followers_count")

	        expect{@order.execute(json)}.to raise_error(ArgumentError, /Key 'user.followers_count' does not exist/)
		end

		it 'Order only one tweet' do
			
			json = @factory_json.produce_tweets_json_array(1)

	        expect(@order.execute(json)).to eq (json)
		end

		it 'Order tweets by user.followers_count - with 2 tweets' do
			
			json = @factory_json.produce_tweets_json_array(2)


			json[0]['user']['followers_count'] = 80
			json[1]['user']['followers_count'] = 900

			json_esperado = Array.new
			json_esperado << json[1]
			json_esperado << json[0]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 3 tweets' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 80
			json[1]['user']['followers_count'] = 900
			json[2]['user']['followers_count'] = 500

			json_esperado = Array.new
			json_esperado << json[1]
			json_esperado << json[2]
			json_esperado << json[0]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 3 tweets' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 980
			json[1]['user']['followers_count'] = 90
			json[2]['user']['followers_count'] = 500

			json_esperado = Array.new
			json_esperado << json[0]
			json_esperado << json[2]
			json_esperado << json[1]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by user.followers_count - with 3 tweets' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 980
			json[1]['user']['followers_count'] = 90
			json[2]['user']['followers_count'] = 1500

			json_esperado = Array.new
			json_esperado << json[2]
			json_esperado << json[0]
			json_esperado << json[1]

	        expect(@order.execute(json)).to eq (json_esperado)
		end
		it 'Order tweets by retweet_count - user.followers_count equals - I' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 500
			json[1]['user']['followers_count'] = 500
			json[2]['user']['followers_count'] = 500

			json[0]['retweet_count'] = 10
			json[1]['retweet_count'] = 50
			json[2]['retweet_count'] = 30

			json_esperado = Array.new
			json_esperado << json[1]
			json_esperado << json[2]
			json_esperado << json[0]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by retweet_count - user.followers_count equals - II' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 500
			json[1]['user']['followers_count'] = 500
			json[2]['user']['followers_count'] = 500

			json[0]['retweet_count'] = 10
			json[1]['retweet_count'] = 5
			json[2]['retweet_count'] = 30

			json_esperado = Array.new
			json_esperado << json[2]
			json_esperado << json[0]
			json_esperado << json[1]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by user.favourites_count - user.followers_count and retweet_count are equals - I' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 500
			json[1]['user']['followers_count'] = 500
			json[2]['user']['followers_count'] = 500

			json[0]['retweet_count'] = 10
			json[1]['retweet_count'] = 10
			json[2]['retweet_count'] = 10

			json[0]['user']['favourites_count'] = 400
			json[1]['user']['favourites_count'] = 200
			json[2]['user']['favourites_count'] = 500

			json_esperado = Array.new
			json_esperado << json[2]
			json_esperado << json[0]
			json_esperado << json[1]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by user.favourites_count - user.followers_count and retweet_count are equals - II' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 500
			json[1]['user']['followers_count'] = 500
			json[2]['user']['followers_count'] = 500

			json[0]['retweet_count'] = 10
			json[1]['retweet_count'] = 10
			json[2]['retweet_count'] = 10

			json[0]['user']['favourites_count'] = 100
			json[1]['user']['favourites_count'] = 200
			json[2]['user']['favourites_count'] = 500

			json_esperado = Array.new
			json_esperado << json[2]
			json_esperado << json[1]
			json_esperado << json[0]

	        expect(@order.execute(json)).to eq (json_esperado)
		end

		it 'Order tweets by user.favourites_count - user.followers_count and retweet_count are equals - III' do
			
			json = @factory_json.produce_tweets_json_array(3)


			json[0]['user']['followers_count'] = 500
			json[1]['user']['followers_count'] = 500
			json[2]['user']['followers_count'] = 500

			json[0]['retweet_count'] = 10
			json[1]['retweet_count'] = 10
			json[2]['retweet_count'] = 10

			json[0]['user']['favourites_count'] = 100
			json[1]['user']['favourites_count'] = 200
			json[2]['user']['favourites_count'] = 300

			json_esperado = Array.new
			json_esperado << json[2]
			json_esperado << json[1]
			json_esperado << json[0]

	        expect(@order.execute(json)).to eq (json_esperado)
		end
	end
end