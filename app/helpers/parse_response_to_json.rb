class ParseResponseToJson

	def parse(body)
		raise ArgumentError.new("JSON invalid") unless json_valid?(body)
		
		json = JSON.parse(body)
		#Rails.logger.debug("Response format:\n#{JSON.pretty_generate(json)}")
		return json
		
	end

	def json_valid?(json)
		begin
			raise JSON::ParserError if json.nil?
			Rails.logger.debug("JSON valid")
			JSON.parse(json)
			return true
		rescue JSON::ParserError
			Rails.logger.debug("ERROR - JSON Invalid")
			return false
		end
	end

end