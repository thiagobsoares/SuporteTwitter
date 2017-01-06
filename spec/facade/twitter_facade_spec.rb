require 'rails_helper'

describe TwitterFacade do
	before(:each) do
    	@factory_json = TweetsJsonFactory.new
    	@factory_obj = UserTweetsObjFactory.new
    	@parse = ParseResponseToJson.new
		@service_mock = double("ServiceMock")
		@twitter_facade = TwitterFacade.new(@service_mock, @parse, nil)
  	end

	describe "get_tweets" do
		it 'get_tweets return Array with tweets' do

			body = @factory_json.produce_body_with_locaweb

			allow(@service_mock).to receive(:call_service).and_return(body)

			pattern_observer = Array.new
			pattern_observer << FilterUserMentions.new(42)
			pattern_observer << OrderTweets.new

			twitter_facade_complete = TwitterFacade.new(@service_mock, @parse, pattern_observer)
			retorno = twitter_facade_complete.get_tweets

			expect(retorno[0]["id_str"]).to eq "728722"
			expect(retorno[0]["entities"]["user_mentions"][0]["screen_name"]).to eq "locaweb"
			expect(retorno[0]["user"]["id_str"]).to eq "213001"
			expect(retorno[0]["in_reply_to_user_id_str"]).to eq "8841"

		end
	end
	describe "group_tweets_by_user" do
		it 'Group tweets by user with same id' do
			body = @factory_json.produce_json_locaweb_group
			allow(@service_mock).to receive(:call_service).and_return(body)

			id_user = "10"
			json = @factory_json.produce_tweets_json_array(3)

			json[0]['user']['id_str'] = id_user
			json[1]['user']['id_str'] = id_user
			json[2]['user']['id_str'] = id_user

			user_esperado = Hash.new

			tweets = Array.new
			tweets << json[0]
			tweets << json[1]
			tweets << json[2]

			user_esperado[id_user] = tweets
			user_retornado = @twitter_facade.group_tweets_by_user

			expect(user_retornado).to eq user_esperado
		end

		it 'Hash of tweets within tweets with same user' do
			body = @factory_json.produce_json_locaweb_group_different
			allow(@service_mock).to receive(:call_service).and_return(body)

			id_user_1 = "10"
			id_user_2 = "20"

			json = @factory_json.produce_tweets_json_array(2)

			json[0]['user']['id_str'] = id_user_1
			json[1]['user']['id_str'] = id_user_2

			user_esperado = Hash.new

			tweets_1 = Array.new
			tweets_1 << json[0]

			tweets_2 = Array.new
			tweets_2 << json[1]

			user_esperado[id_user_1] = tweets_1
			user_esperado[id_user_2] = tweets_2

			user_retornado = @twitter_facade.group_tweets_by_user

			expect(user_retornado).to eq user_esperado
		end


		it 'Tweets - body is nil' do
			body = nil

			allow(@service_mock).to receive(:call_service).and_return(body)
		
			user_retornado = @twitter_facade.get_tweets

			expect(user_retornado).to be false
			
		end
	end
end