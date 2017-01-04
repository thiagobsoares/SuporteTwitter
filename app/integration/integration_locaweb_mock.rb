=begin
	Class responsavel por chamar o serviço e traduzir para JSON
=end

require 'open-uri'
require 'json'

class IntegrationLocawebMock

	def call_service(params = {})
		begin
			Rails.logger.info("Start: IntegrationLocawebMock")

			params[:url] ||= "http://tweeps.locaweb.com.br/tweeps"
			params[:header] ||= {"username" => "thiagobsoares@globomail.com"}

			Rails.logger.debug("url: #{params[:url]}")
			Rails.logger.debug("header: #{params[:header]}")

			response = open(params[:url], params[:header])
			Rails.logger.info("Status response: #{response.status}")

			@body = response.read

			return @body
		rescue StandardError => e
			Rails.logger.error("Error - call service")   
			Rails.logger.error(e.message)
			raise BadConnection.new("Error connection")
		end
	end

end

