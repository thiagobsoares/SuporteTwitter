require 'rails_helper'

describe TwitterFacadeBuilder do
	it 'builder sucess' do
	  builder = TwitterFacadeBuilder.new
	  twitter = builder.builder

	  expect(twitter.class).to eq TwitterFacade
	end
end
