require 'date'
class Tweet
	attr_reader :id, :user, :retweets, :likes, :text, :date

	BASE_URL = "https://twitter.com"

	def initialize(params)

		@id = params[:id]
		@user = params[:user]
		@retweets = params[:retweets]
		@likes = params[:likes]
		@text = params[:text]
		@date = params[:date]

		raise ArgumentError.new("Error - id nil") if id.nil?
		raise ArgumentError.new("Error - user nil") if user.nil?
		raise ArgumentError.new("Error - retweets nil") if retweets.nil?
		raise ArgumentError.new("Error - likes nil") if likes.nil?
		raise ArgumentError.new("Error - text nil") if text.nil?
		raise ArgumentError.new("Error - date nil") if date.nil?
	end

	def url
		"#{BASE_URL}/#{self.user}/status/#{self.id}"
	end

	def date_format
		
		d = DateTime.parse(self.date)
		d.strftime('%d/%m/%y %H:%M:%S')
	end
end