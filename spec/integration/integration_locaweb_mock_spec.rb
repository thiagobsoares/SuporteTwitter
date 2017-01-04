require 'rails_helper'


describe IntegrationLocawebMock do

	it 'connection service - default parameter' do

		service = IntegrationLocawebMock.new
		response = service.call_service

		expect(response).to include "statuses"

	end

	it 'connection service - passing parameter' do
		params = Hash.new

		params[:url] = "http://tweeps.locaweb.com.br/tweeps"
		params[:header] = {"username" => "thiagobsoares@globomail.com"}

		service = IntegrationLocawebMock.new
		resposta = service.call_service(params)

		expect(resposta).to include "statuses"

	end
	it 'connection service with header invalid' do
		params = Hash.new

		params[:url] = "http://tweeps.locaweb.com.br/tweeps"
		params[:header] = {"_" => "_"}

		service = IntegrationLocawebMock.new
		

		expect{service.call_service(params)}.to raise_error(BadConnection)

	end

	it 'connection service with url invalid' do
		params = Hash.new

		params[:url] = "http://tweeps.lcw.com.br/tweeps"
		params[:header] = {"username" => "thiagobsoares@globomail.com"}

		service = IntegrationLocawebMock.new
		

		expect{service.call_service(params)}.to raise_error(BadConnection)

	end
end