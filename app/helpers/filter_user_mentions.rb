class FilterUserMentions

	attr_reader :id_user

	def initialize(id_user)
		@id_user = id_user
	end

	def execute(tweets)
		Rails.logger.info("Filter tweets by user: #{@id_user}")

		tweets_filtered = tweets.select do |tweet|
			raise ArgumentError.new("Error - key 'in_reply_to_user_id' does not exist") unless tweet.has_key?("in_reply_to_user_id")
			tweet['in_reply_to_user_id'] != @id_user and usuario_mencionado?(tweet)
		end

		return tweets_filtered
	end

	def usuario_mencionado?(tweet)

		raise ArgumentError.new("Error - key 'entities' does not exist") unless tweet.has_key?("entities")
		raise ArgumentError.new("Error - key 'entities.user_mentions' does not exist") unless tweet["entities"].has_key?("user_mentions")

		result = tweet["entities"]["user_mentions"].select do |mention|
			raise ArgumentError.new("Error - key 'entities.user_mentions.id' does not exist") unless mention.has_key?("id")
	  		mention["id"] == @id_user
	  	end
	  	not result.empty?
	end
end