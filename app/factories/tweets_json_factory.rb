class TweetsJsonFactory

	def produce_tweets_json
		file = File.open("app/factories/twitter-locaweb-mock.txt", 'r').read
		json = JSON.parse(file)
		tweets = json["statuses"]

		resultado = tweets[0]
	end

	def produce_all_tweets_json_array
		file = File.open("app/factories/twitter-locaweb-mock.txt", 'r').read
		json = JSON.parse(file)
		tweets = json["statuses"]
	end 

	def produce_tweets_json_array(quantidade = 2)
		file = File.open("app/factories/twitter-locaweb-mock.txt", 'r').read
		json = JSON.parse(file)
		tweets = json["statuses"]

		resultado = Array.new

		quantidade -= 1

		for i in (0..quantidade)
			resultado << tweets[i]
		end

		resultado
	end

	def produce_body
		File.open("app/factories/twitter-locaweb-body.txt", 'r').read
	end

	def produce_body_with_locaweb
		File.open("app/factories/twitter-locaweb-body-with-locaweb.txt", 'r').read
	end

	def produce_json_locaweb_group
		File.open("app/factories/twitter-locaweb-mock-group.txt", 'r').read
	end

	def produce_json_locaweb_group_different
		File.open("app/factories/twitter-locaweb-mock-group-user-different.txt", 'r').read
	end
	
end