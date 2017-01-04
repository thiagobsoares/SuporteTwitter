require 'rails_helper'

describe User do
  
  before(:each) do
    @factory = UserTweetsObjFactory.new
  end

  it 'create a new user' do

    id = 1
    name = "ThiagoSoares"
    fallowers = 10

    user = @factory.produce_user

    expect(user.id).to eq id
    expect(user.name).to eq name
    expect(user.fallowers).to eq fallowers


  end

  

  it 'url formatted' do


    params = Hash.new 
    params[:name] = "Carlos"
    user = @factory.produce_user(params)

    url = "https://twitter.com/#{params[:name]}"

    expect(user.url).to eq url

  end

  it 'ArgumentError - id nil' do

    params = Hash.new

    params[:id] = nil
    params[:name] = "Thiago Soares"
    params[:fallowers] = 10
    params[:tweets] = Array.new

    expect{User.new(params)}.to raise_error(ArgumentError, /Error - id nil/)

  end

  it 'ArgumentError - name nil' do

    params = Hash.new

    params[:id] = 2
    params[:name] = nil
    params[:fallowers] = 10
    params[:tweets] = Array.new

    expect{User.new(params)}.to raise_error(ArgumentError, /Error - name nil/)

  end

  it 'ArgumentError - fallowers nil' do

    params = Hash.new

    params[:id] = 2
    params[:name] = "Thiago Soares"
    params[:fallowers] = nil
    params[:tweets] = Array.new

    expect{User.new(params)}.to raise_error(ArgumentError, /Error - fallowers nil/)

  end

  it 'ArgumentError - tweets nil' do

    params = Hash.new

    params[:id] = 2
    params[:name] = "Thiago Soares"
    params[:fallowers] = 10
    params[:tweets] = nil

    expect{User.new(params)}.to raise_error(ArgumentError, /Error - tweets nil/)

  end

end