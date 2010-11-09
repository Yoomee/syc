module TwitterHelper
  
  # TODO: auto_link call may need to change for new version of Rails
  # auto_link(tweet, :href_options => {:target => "_blank"})
  def highlight_tweet_links tweet
    return '' if tweet.nil?
    tweet = auto_link(tweet, :all, :target => "_blank")
    highlight_twitter_users(highlight_twitter_hash_tags(tweet))
  end
  
  def highlight_twitter_users(tweet)
    tweet.gsub(/@([\w|\d]+)/, '@<a target="_blank" href="http://www.twitter.com/\1">\1</a>')
  end
  
  def highlight_twitter_hash_tags(tweet)
    tweet.gsub(/#([\w|\d]+)/, '#<a target="_blank" href="http://twitter.com/search?q=%23\1">\1</a>')
  end
  
end