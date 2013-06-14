module ApplicationControllerConcerns::Twitter
    
    def self.included(klass)
      klass.helper_method :get_latest_tweet_from
      klass.helper_method :get_latest_tweets_from
    end

  def get_latest_tweet_from(user, replies = false)
    get_latest_tweets_from(user, 1, replies).first
  end

  def get_latest_tweets_from(user, limit = 4, replies = false)
    if false #Rails.cache.to_s.in?(["ActiveSupport::Cache::MemCacheStore", "MemCacheStoreWithDeleteMatched"])
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
      url = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=#{limit*15}&include_entities=false&screen_name=#{user}&include_rts=true&exclude_replies=true"
      tweets_json = open(url, "Authorization" => "Bearer AAAAAAAAAAAAAAAAAAAAAE6ORQAAAAAAIHgBvYwKX6VNYCvOAopBkW4XGl8%3D0wGL20mu9A5u12JvTMhsdbteFi77SPOnE1wURuKTjA").read
      tweets_array = ActiveSupport::JSON.decode(tweets_json)
      tweets_array.first(limit).collect{|t| t['text']}
    rescue
      ""
    end
  end
  
end