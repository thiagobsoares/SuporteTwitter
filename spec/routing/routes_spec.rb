require 'rails_helper'

describe "TweetsController" do
	it "routes to #tweets" do
		expect(:get => "tweets").to route_to(
        :controller => "tweets",
        :action => "index")
	end     
end