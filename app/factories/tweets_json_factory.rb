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

	def produce_tweets_json_hash(quantidade = 2)
		file = File.open("app/factories/twitter-locaweb-mock.txt", 'r').read
		json = JSON.parse(file)
		tweets = json["statuses"]
		resultado = Hash.new

		quantidade -= 1

		for i in (0..quantidade)
			array = Array.new
			array << tweets[i]
			resultado[tweets[i]['user']['id_str']] = array
		end

		resultado
	end

	def produce_body
		File.open("app/factories/twitter-locaweb-mock.txt", 'r').read
	end

	def produce_body_locaweb
		File.open("app/factories/twitter-locaweb-body.txt", 'r').read
	end
	
end