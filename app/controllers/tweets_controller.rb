class TweetsController < ApplicationController

	ID_LOCAWEB = 42

	def index
		Rails.logger.info("Start API - Controller")
		twitter  = TwitterFacade.new(IntegrationLocawebMock.new)
		Rails.logger.info("Service: #{twitter.class}")
		
		@users_tweets = twitter.tweets(ID_LOCAWEB)

		if @users_tweets == false
			@error = true
		end

	end

	
end
