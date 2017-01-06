require 'rails_helper'

describe FilterUserMentions do

	before(:each) do
    	@factory_json = TweetsJsonFactory.new
		@filter = FilterUserMentions.new(ID_LOCAWEB)
  	end

	describe "execute filter" do
		
		it 'Key user.in_reply_to_user_id does not exist' do
			
			json = @factory_json.produce_tweets_json_array
			json[0].delete("in_reply_to_user_id")

	        expect{@filter.execute(json)}.to raise_error(ArgumentError, /Error - key 'in_reply_to_user_id' does not exist/)
		end

		it 'Key entities does not exist' do
			
			json = @factory_json.produce_tweets_json_array
			json[0].delete("entities")

	        expect{@filter.execute(json)}.to raise_error(ArgumentError, /Error - key 'entities' does not exist/)
		end
	
		it 'Key entities.user_mentions does not exist' do
			
			json = @factory_json.produce_tweets_json_array
			json[0]['entities'].delete("user_mentions")

	        expect{@filter.execute(json)}.to raise_error(ArgumentError, /Error - key 'entities.user_mentions' does not exist/)
		end	

		it 'Key entities.user_mentions.id does not exist' do
			
			json = @factory_json.produce_tweets_json_array
			json[0]['entities']["user_mentions"][0].delete("id")

	        expect{@filter.execute(json)}.to raise_error(ArgumentError, /Error - key 'entities.user_mentions.id' does not exist/)
		end	

		it 'Filter tweets by user_mention - locaweb(ID_LOCAWEB) and dont reply' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[0]["in_reply_to_user_id"] = 10 


	        json_esperado = Array.new
	        json_esperado << json[0]
			
			json_retornado = @filter.execute(json)

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Dont have tweets with user mention' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[0]["in_reply_to_user_id"] = ID_LOCAWEB 

			json_retornado = @filter.execute(json)

			json_esperado = Array.new

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention but it is replay' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = 75
			json[0]["in_reply_to_user_id"] = ID_LOCAWEB 

			json_retornado = @filter.execute(json)

			json_esperado = Array.new

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Dont have tweets with user mention and dont replay' do
			
			json = @factory_json.produce_tweets_json_array(1)
			json[0]["entities"]["user_mentions"][0]["id"] = 75
			json[0]["in_reply_to_user_id"] = 10

			json_retornado = @filter.execute(json)

			json_esperado = Array.new

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention - locaweb(ID_LOCAWEB) and dont reply - TWO tweets' do
			
			id_user = 700

			json = @factory_json.produce_tweets_json_array(2)
			json[0]["user"]["id_str"] = id_user
			json[0]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[0]["in_reply_to_user_id"] = 10

			json[1]["user"]["id_str"] = id_user
			json[1]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[1]["in_reply_to_user_id"] = 15 


	        json_esperado = Array.new
	        json_esperado << json[0]
	        json_esperado << json[1]
			
			json_retornado = @filter.execute(json)

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention - locaweb(ID_LOCAWEB) and dont reply - Two tweets same user' do
			
			id_user = 700
			id_other_user_1 = 10
			id_other_user_2 = 30

			json = @factory_json.produce_tweets_json_array(4)

			json[0]["user"]["id_str"] = id_user
			json[0]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[0]["in_reply_to_user_id"] = 10

			json[1]["user"]["id_str"] = id_user
			json[1]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[1]["in_reply_to_user_id"] = 15 

			json[2]["user"]["id_str"] = id_other_user_1
			json[2]["in_reply_to_user_id"] = 150

			json[3]["user"]["id_str"] = id_other_user_2
			json[3]["entities"]["user_mentions"][0]["id"] = 31
			json[3]["in_reply_to_user_id"] = 90 

	        json_esperado = Array.new
	        json_esperado << json[0]
	        json_esperado << json[1]

			json_retornado = @filter.execute(json)

	        expect(json_retornado).to eq (json_esperado)
		end	

		it 'Filter tweets by user_mention - locaweb(ID_LOCAWEB) and dont reply - Two tweets same user and one tweet other user' do
			
			id_user = 700
			id_other_user_1 = 10
			id_other_user_2 = 30

			json = @factory_json.produce_tweets_json_array(4)

			json[0]["user"]["id_str"] = id_user
			json[0]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[0]["in_reply_to_user_id"] = 10

			json[1]["user"]["id_str"] = id_user
			json[1]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[1]["in_reply_to_user_id"] = 15 

			json[2]["user"]["id_str"] = id_other_user_1
			json[2]["in_reply_to_user_id"] = 150

			json[3]["user"]["id_str"] = id_other_user_2
			json[3]["entities"]["user_mentions"][0]["id"] = ID_LOCAWEB
			json[3]["in_reply_to_user_id"] = 90 

	        json_esperado = Array.new
	        json_esperado << json[0]
	        json_esperado << json[1]
	        json_esperado << json[3]

			json_retornado = @filter.execute(json)

	        expect(json_retornado).to eq (json_esperado)
		end	
	end
end