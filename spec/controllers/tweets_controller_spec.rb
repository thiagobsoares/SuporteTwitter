require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
	it 'has a 200 status code' do
	  get :index
	  expect(response.status).to eq(200)
	end

	it 'renders the index page' do
	  get :index
	  expect(response).to render_template('index')
	end
end
