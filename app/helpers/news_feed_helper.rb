module NewsFeedHelper
  
  def news_feed_option_links(news_feed_item, options = {})
    link_if_allowed("Delete", news_feed_item, {:method => :delete, :class => 'delete'})
  end

  def render_news_feed(*args)
    options = args.extract_options!.reverse_merge(:per_page => 10)
    object = args.first
    news_feed_items = object ? object.news_feed_items : NewsFeedItem.all.paginate(:page => 1, :per_page => options[:per_page])
    render :partial => 'news_feed/news_feed', :locals => {:news_feed_items => news_feed_items}
  end
  
  def render_news_feed_item(news_feed_item)
    content_tag(:div, :class => "news_feed_item") do
      if view_exists?("news_feed/_#{news_feed_item.partial_name}")
        render("news_feed/#{news_feed_item.partial_name}", :news_feed_item => news_feed_item, news_feed_item.attachable_type.undersore.to_sym => news_feed_item.attachable)
      else
        render('news_feed/news_feed_item', :news_feed_item => news_feed_item)
      end
    end
  end
  
  def attachable_description(news_feed_item)
    if news_feed_item.updated?
      out = "the #{news_feed_item.attachable_type.underscore.humanize}"
    else
      out = "a new #{news_feed_item.attachable_type.underscore.humanize}"
    end
    news_feed_item.attachable_name ? out + " called #{link_to(news_feed_item.attachable_name, news_feed_item.attachable)}" : out
  end
  
end