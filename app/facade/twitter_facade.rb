class TwitterFacade
	def initialize(service)
		@service = service
	end

	def tweets(id_user)

		body_response = @service.call_service

		begin

			raise ArgumentError.new("Return service is nil") if body_response.nil?

			tweets = tweets_json(body_response)
			tweets = tweets["statuses"]

			tweets_grouped_by_user = filter_by_user_mention(tweets, id_user)
			tweets_order_by_followers = order_tweets(tweets_grouped_by_user)
			
			return parse_json_to_obj(tweets_order_by_followers)

		rescue ArgumentError => argument_error
			Rails.logger.error("Error -  ArgumentError: #{argument_error.message}")
			return false

		rescue StandardError => error
			Rails.logger.error("Error: #{error.message}")
			return false
		end

	end

	def tweets_json(body)
		raise ArgumentError.new("JSON invalid") unless json_valid?(body)
		
		json = JSON.parse(body)
		Rails.logger.debug("Response format:\n#{JSON.pretty_generate(json)}")
		return json
		
	end

	def json_valid?(json)
		begin
			raise JSON::ParserError if json.nil?

			JSON.parse(json)
			return true
		rescue JSON::ParserError
			return false
		end
	end

	def usuario_mencionado?(tweet, usr_id)

		raise ArgumentError.new("Error - key 'entities' does not exist") unless tweet.has_key?("entities")
		raise ArgumentError.new("Error - key 'entities.user_mentions' does not exist") unless tweet["entities"].has_key?("user_mentions")

		result = tweet["entities"]["user_mentions"].select do |mention|
			raise ArgumentError.new("Error - key 'entities.user_mentions.id' does not exist") unless mention.has_key?("id")
	  		mention["id"] == usr_id
	  	end
	  	not result.empty?
	end

	def parse_json_to_obj(tweets_order_by_followers)
		Rails.logger.debug("Start parse json to obj")
		users_tweets = Array.new 

		tweets_order_by_followers.each do |array_tweets|
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


	def filter_by_user_mention(tweets, id_user)
		Rails.logger.info("Filter and group tweets by user: #{id_user}")

		tweets_filtered = tweets.select do |tweet|
			raise ArgumentError.new("Error - key 'in_reply_to_user_id' does not exist") unless tweet.has_key?("in_reply_to_user_id")
			tweet['in_reply_to_user_id'] != id_user and usuario_mencionado?(tweet, id_user)
		end

		tweets_grouped_by_user = tweets_filtered.group_by do |tweet|
			raise ArgumentError.new("Key 'user' does not exist") unless tweet.has_key?("user")
			raise ArgumentError.new("Key 'user.id_str' does not exist") unless tweet["user"].has_key?("id_str")
			tweet['user']['id_str']
		end
		Rails.logger.info("Tweets filtered: #{tweets_grouped_by_user.length}")
		return tweets_grouped_by_user
	end

	def order_tweets(tweets_grouped_by_user)
		Rails.logger.info("Ordenando tweets filtrados")

		tweets_grouped_by_user.each do |id_str, tweets|

			

			tweets_grouped_by_user[id_str] = tweets.sort_by do |tweet| 

				raise ArgumentError.new("Key 'retweet_count' does not exist") unless tweet.has_key?("retweet_count")
				raise ArgumentError.new("Key 'user' does not exist") unless tweet.has_key?("user")
				raise ArgumentError.new("Key 'user.favourites_count' does not exist") unless tweet["user"].has_key?("favourites_count")

				[-tweet['retweet_count'], -tweet['user']['favourites_count']]
			end
		end 

		#ordenando os usuários pelo numerio de seguidores, retweets e likes
		tweets_order_by_followers = tweets_grouped_by_user.sort_by do |_, tweet|  
			raise ArgumentError.new("Key 'user' does not exist") unless tweet[0].has_key?("user")
			raise ArgumentError.new("Key 'user.followers_count' does not exist") unless tweet[0]["user"].has_key?("followers_count")
			

			[-tweet[0]['user']['followers_count'], -tweet[0]['retweet_count'], -tweet[0]['user']['favourites_count']]
		end
	end
end