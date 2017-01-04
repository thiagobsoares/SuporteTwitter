class UserTweetsObjFactory

    def produce_user(u_params = {})

        users_tweets = Array.new
        users_tweets << self.produce_tweet
        
        u_params[:id] ||= 1
        u_params[:name] ||= "ThiagoSoares"
        u_params[:fallowers] ||= 10
        u_params[:tweets] ||= users_tweets

        user = User.new(u_params)

    end

    def produce_tweet(params = {})

        params[:id] ||= 1
        params[:user] ||= "ThiagoSoares"
        params[:retweets] ||= 10
        params[:likes] ||= 20
        params[:text] ||= "Hello Word"
        params[:date] ||= "Mon Sep 24 03:35:21 +0000 2012"

        tweet = Tweet.new(params)
  end

end