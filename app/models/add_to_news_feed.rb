module AddToNewsFeed
  
  def self.included(klass)
    if klass.to_s == "Member"
      klass.has_many :news_feed_items, :dependent => :destroy
    else
      klass.has_many :news_feed_items, :as => :attachable, :dependent => :destroy
    end
    klass.cattr_accessor :news_feed_actions, :on_news_feed_attributes, :except_news_feed_attributes, :news_feed_weighting
    klass.before_save :save_to_news_feed
  end

  attr_boolean_writer :skip_news_feed
  attr_reader :skip_news_feed

  def news_feed_item
    news_feed_items.latest.limit(1).first
  end

  private
  def save_to_news_feed
    unless skip_news_feed
      item_attributes = {}
      if new_record?
        item_attributes[:updated] = false if news_feed_actions.include?('create')
      elsif news_feed_actions.include?('update')
        attribute_changes = on_news_feed_attributes.empty? ? changes.keys - except_news_feed_attributes : changes.keys & on_news_feed_attributes
        item_attributes.merge(:updated => true, :attribute_changes => attribute_changes.join(', ')) unless attribute_changes.empty?
      end
      unless item_attributes.empty?
        if self.class.to_s == "Member"
          item_attributes[:attachable] = self
        else
          item_attributes[:member] = (respond_to?(:member) ? member : nil)
        end
        news_feed_items.build(item_attributes.merge!(:weighting => news_feed_weighting))
      end
      skip_news_feed = true      
    end
  end

end