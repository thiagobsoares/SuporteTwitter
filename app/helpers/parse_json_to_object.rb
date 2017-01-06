class ParseJsonToObject

	def parse(tweets_json)
		Rails.logger.debug("Start parse json to object")
		users_tweets = Array.new 

		tweets_json.each do |array_tweets|
			tweets_user = Array.new
			user = array_tweets[1][0]['user']

			Rails.logger.debug("Usuário: #{user['screen_name']}")

			array_tweets[1].each do |tweet|
				params = Hash.new

				Rails.logger.debug("ID Tweet: #{tweet['id']}")

				raise ArgumentError.new("Error - key 'id' does not exist") unless tweet.has_key?("id")
				raise ArgumentError.new("Error - key 'user' does not exist") unless tweet.has_key?("user")
				raise ArgumentError.new("Error - key 'user.screen_name' does not exist") unless tweet["user"].has_key?("screen_name")
				raise ArgumentError.new("Error - key 'retweet_count' does not exist") unless tweet.has_key?("retweet_count")
				raise ArgumentError.new("Error - key 'user.favourites_count' does not exist") unless tweet["user"].has_key?("favourites_count")
				raise ArgumentError.new("Error - key 'text' does not exist") unless tweet.has_key?("text")
				raise ArgumentError.new("Error - key 'created_at' does not exist") unless tweet.has_key?("created_at")

				params[:id] = tweet['id']
				params[:user] = tweet['user']['screen_name']
				params[:retweets] = tweet['retweet_count']
				params[:likes] = tweet['user']['favourites_count']
				params[:text] = tweet['text']
				params[:date] = tweet['created_at']

				tweet_obj = Tweet.new(params)
				tweets_user << tweet_obj
			end
			params = Hash.new

			raise ArgumentError.new("Error - key 'user.id' does not exist") unless user.has_key?("id")
			raise ArgumentError.new("Error - key 'user.screen_name' does not exist") unless user.has_key?("screen_name")
			raise ArgumentError.new("Error - key 'user.fallowers_count' does not exist") unless user.has_key?("followers_count")

			params[:id] = user['id']
			params[:name] = user['screen_name']
			params[:fallowers] = user['followers_count']
			params[:tweets] = tweets_user

			Rails.logger.debug("User #{user['screen_name']} has  #{tweets_user.length} tweet(s).")

			user_obj = User.new(params)
			users_tweets << user_obj
		end

		users_tweets
	end
end