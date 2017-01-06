class OrderTweets

	def execute(tweets)
		Rails.logger.info("Order tweets - followers_count, retweet_count, favourites_count")

		tweets_order = tweets.sort_by do |tweet|  
			raise ArgumentError.new("Key 'user' does not exist") unless tweet.has_key?("user")
			raise ArgumentError.new("Key 'user.followers_count' does not exist") unless tweet["user"].has_key?("followers_count")
			raise ArgumentError.new("Key 'retweet_count' does not exist") unless tweet.has_key?("retweet_count")
			raise ArgumentError.new("Key 'user.favourites_count' does not exist") unless tweet["user"].has_key?("favourites_count")

			[-tweet['user']['followers_count'], -tweet['retweet_count'], -tweet['user']['favourites_count']]
		end
	end

end