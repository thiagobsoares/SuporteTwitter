class TwitterFacadeBuilder

	def builder

		Rails.logger.debug("Start API - TwitterFacadeBuilder")

		service = IntegrationLocawebMock.new

		pattern_observer = Array.new
		pattern_observer << FilterUserMentions.new(42)
		pattern_observer << OrderTweets.new

		parse = ParseResponseToJson.new


		Rails.logger.info("Service: #{service.class}")
		Rails.logger.info("Service: #{parse.class}")
		Rails.logger.info("Service: #{pattern_observer}")

		@twitter_facade = TwitterFacade.new(service, parse, pattern_observer)

	end

end