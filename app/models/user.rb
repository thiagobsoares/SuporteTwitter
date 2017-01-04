class User
	attr_reader :id, :name, :fallowers, :tweets

	BASE_URL = "https://twitter.com"

	def initialize(params)
		@id = params[:id]
		@name = params[:name]
		@fallowers = params[:fallowers]
		@tweets = params[:tweets]

		raise ArgumentError.new("Error - id nil") if id.nil?
		raise ArgumentError.new("Error - name nil") if name.nil?
		raise ArgumentError.new("Error - fallowers nil") if fallowers.nil?
		raise ArgumentError.new("Error - tweets nil") if tweets.nil?

	end

	def url
		"#{BASE_URL}/#{self.name}"
	end
end