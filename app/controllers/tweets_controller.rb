class TweetsController < ApplicationController

	ID_LOCAWEB = 42

	def index

		@twitter_builder = TwitterFacadeBuilder.new
		@parseObject = ParseJsonToObject.new


		Rails.logger.info("Start API - Controller")


		twitter_facade  = @twitter_builder.builder
		tweets = twitter_facade.group_tweets_by_user		
		@users_tweets = @parseObject.parse(tweets)


		

		if @users_tweets == false
			Rails.logger.info("ERROR in API - Controller")
			@error = true
		end

		Rails.logger.info("End API - Controller")
		@users_tweets

	end
end
