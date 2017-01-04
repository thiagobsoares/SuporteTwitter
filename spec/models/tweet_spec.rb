require 'rails_helper'

describe Tweet do
  before(:each) do
      @factory = UserTweetsObjFactory.new
  end

  it 'create a new tweet' do

    id = 1
    user = "ThiagoSoares"
    retweets = 10
    likes = 20
    text = "Hello Word"
    date = "Mon Sep 24 03:35:21 +0000 2012"

    tweet = @factory.produce_tweet

    expect(tweet.id).to eq id
    expect(tweet.user).to eq user
    expect(tweet.retweets).to eq retweets
    expect(tweet.likes).to eq likes
    expect(tweet.text).to eq text
    expect(tweet.date).to eq date

  end

  

  it 'url formatted' do


    params = Hash.new 
    params[:id] = 67
    params[:user] = "Carlos"
    tweet = @factory.produce_tweet(params)

    url = "https://twitter.com/#{params[:user]}/status/#{params[:id]}"

    expect(tweet.url).to eq url

  end

  it 'date formatted' do

    params = Hash.new 
    params[:date] = "Fri Jan 24 13:30:24 +0000 2016"
    tweet = @factory.produce_tweet(params)

    date = "24/01/16 13:30:24"

    expect(tweet.date_format).to eq date

  end

  it 'ArgumentError - id nil' do

    params = Hash.new

    params[:id] = nil
    params[:user] = "Thiago Soares"
    params[:retweets] = 10
    params[:likes] = 20
    params[:text] = "Hello Word"
    params[:date] = "Mon Sep 24 03:35:21 +0000 2012"

    expect{Tweet.new(params)}.to raise_error(ArgumentError, /Error - id nil/)

  end
  it 'ArgumentError - user nil' do

    params = Hash.new

    params[:id] = 2
    params[:user] = nil
    params[:retweets] = 10
    params[:likes] = 20
    params[:text] = "Hello Word"
    params[:date] = "Mon Sep 24 03:35:21 +0000 2012"

    expect{Tweet.new(params)}.to raise_error(ArgumentError, /Error - user nil/)

  end
  it 'ArgumentError - retweets nil' do

    params = Hash.new

    params[:id] = 2
    params[:user] = "Thiago Soares"
    params[:retweets] = nil
    params[:likes] = 20
    params[:text] = "Hello Word"
    params[:date] = "Mon Sep 24 03:35:21 +0000 2012"

    expect{Tweet.new(params)}.to raise_error(ArgumentError, /Error - retweets nil/)

  end
  it 'ArgumentError - likes nil' do

    params = Hash.new

    params[:id] = 2
    params[:user] = "Thiago Soares"
    params[:retweets] = 10
    params[:likes] = nil
    params[:text] = "Hello Word"
    params[:date] = "Mon Sep 24 03:35:21 +0000 2012"

    expect{Tweet.new(params)}.to raise_error(ArgumentError, /Error - likes nil/)

  end
  it 'ArgumentError - text nil' do

    params = Hash.new

    params[:id] = 2
    params[:user] = "Thiago Soares"
    params[:retweets] = 10
    params[:likes] = 20
    params[:text] = nil
    params[:date] = "Mon Sep 24 03:35:21 +0000 2012"

    expect{Tweet.new(params)}.to raise_error(ArgumentError, /Error - text nil/)

  end
  it 'ArgumentError - data nil' do

    params = Hash.new

    params[:id] = 2
    params[:user] = "Thiago Soares"
    params[:retweets] = 10
    params[:likes] = 20
    params[:text] = "Hello Word"
    params[:date] = nil

    expect{Tweet.new(params)}.to raise_error(ArgumentError, /Error - date nil/)

  end

  it 'invalid data' do

    params = Hash.new

    params[:id] = 2
    params[:user] = "Thiago Soares"
    params[:retweets] = 10
    params[:likes] = 20
    params[:text] = "Hello Word"
    params[:date] = "X"

    tweet = Tweet.new(params)

    expect{tweet.date_format}.to raise_error(ArgumentError, /invalid date/)

  end
end
