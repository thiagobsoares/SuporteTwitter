require 'rails_helper'

describe ParseResponseToJson do
	before(:each) do
    	@factory_json = TweetsJsonFactory.new
		@parse_response_to_json = ParseResponseToJson.new
  	end

	describe "json_valid?" do
		it 'JSON valid' do
			json = @factory_json.produce_body
			json_valid = @parse_response_to_json.json_valid?(json)

			expect(json_valid).to be true
		end

		it 'JSON invalid' do
			json = "JSON INVALID!"
			json_invalid = @parse_response_to_json.json_valid?(json)

			expect(json_invalid).to be false
		end

		it 'JSON nil' do
			json = nil
			json_nil = @parse_response_to_json.json_valid?(json)

			expect(json_nil).to be false
		end
	end


	describe "parse" do
		it 'Parse body-response to JSON' do

			body = @factory_json.produce_body
			json_return = @parse_response_to_json.parse(body)["statuses"]

			json_expect  = @factory_json.produce_all_tweets_json_array

			expect(json_return).to eq(json_expect)

		end

		it 'ArgumentError - body nil' do

			body = nil

			expect{@parse_response_to_json.parse(body)}.to raise_error(ArgumentError, /JSON invalid/)

		end

		it 'ArgumentError - body invalid' do

			body = "It isn't json"

			expect{@parse_response_to_json.parse(body)}.to raise_error(ArgumentError, /JSON invalid/)

		end
	end
end