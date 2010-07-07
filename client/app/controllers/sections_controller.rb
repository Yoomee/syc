SectionsController.class_eval do
  
  before_filter :set_news_section_items_per_page, :only => :show
  after_filter :reset_news_section_items_per_page, :only => :show
  
  private
  def set_news_section_items_per_page
    @per_page = APP_CONFIG[:latest_stories_items_per_page]
    APP_CONFIG[:latest_stories_items_per_page] = 4 if @section == Section::news
  end
  
  def reset_news_section_items_per_page
    APP_CONFIG[:latest_stories_items_per_page] = @per_page
  end
  
end