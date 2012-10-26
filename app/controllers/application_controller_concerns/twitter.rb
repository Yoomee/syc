require 'rss'
module ApplicationControllerConcerns::Twitter
    
    def self.included(klass)
      klass.helper_method :get_latest_tweet_from
      klass.helper_method :get_latest_tweets_from
    end

  def get_latest_tweet_from(user, replies = false)
    get_latest_tweets_from(user, 1, replies).first
  end

  def get_latest_tweets_from(user, limit = 4, replies = false)
    if Rails.cache.to_s.in?(["ActiveSupport::Cache::MemCacheStore", "MemCacheStoreWithDeleteMatched"])
      Rails.cache.fetch("latest_tweets_from_#{user}#{replies ? '_with_replies' : '_without_replies'}", :expires_in => 20.seconds) do
        fetch_latest_tweets_from(user, limit, replies)
      end
    else
      fetch_latest_tweets_from(user, limit, replies)
    end
  end
  
  def fetch_latest_tweets_from(user, limit, replies)
    begin
      Rails.logger.info("Getting new tweets")
      rss = RSS::Parser.parse(open("https://api.twitter.com/1/statuses/user_timeline.rss?screen_name=#{user}").read, false)
      items = replies ? rss.items : rss.items.reject {|item| item.title.match(/^.[^:]+:\s+@/)}
      items.first(limit).collect {|i| /^.[^:]+:\s+((\s|.)*)/.match(i.title)[1].gsub(%r{\n}, ' ')}
    rescue
      ""
    end
  end
  
end