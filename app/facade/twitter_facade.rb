class TwitterFacade

	attr_reader :tweets

	def initialize(service, parse, pattern_observer)
		@service = service
		@parse = parse
		@pattern_observer = pattern_observer
	end

	def get_tweets()

		body_response = @service.call_service
		
		begin

			raise ArgumentError.new("Return service is nil") if body_response.nil?

			@tweets = @parse.parse(body_response)
			@tweets = tweets["statuses"]

			unless @pattern_observer.nil?
				@pattern_observer.each do |pattern|
					@tweets = pattern.execute(@tweets)
				end
			end

			return @tweets
			
		rescue ArgumentError => argument_error
			Rails.logger.error("Error -  ArgumentError: #{argument_error.message}")
			return false

		rescue StandardError => error
			Rails.logger.error("Error: #{error.message}")
			return false
		end

	end





	def group_tweets_by_user()
		if @tweets.nil? 
			self.get_tweets()
		end

		tweets_grouped_by_user = @tweets.group_by do |tweet|
			raise ArgumentError.new("Key 'user' does not exist") unless tweet.has_key?("user")
			raise ArgumentError.new("Key 'user.id_str' does not exist") unless tweet["user"].has_key?("id_str")
			tweet['user']['id_str']
		end
		Rails.logger.info("Count Tweets group: #{tweets_grouped_by_user.length}")
		return tweets_grouped_by_user
	end

end