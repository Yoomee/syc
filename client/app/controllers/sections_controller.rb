SectionsController.class_eval do
  
  before_filter :set_news_section_items_per_page, :only => :show
  after_filter :reset_news_section_items_per_page, :only => :show

  def show_with_news
    if @section == Section.news
      @pages_sections = @section.pages.published.sort_by(&:publish_on).reverse.paginate(:page => params[:page], :per_page => (APP_CONFIG[:latest_stories_items_per_page] || 3))
      render :action => 'latest_stories'
    else
      show_without_news
    end
  end
  alias_method_chain :show, :news

  private
  def set_news_section_items_per_page
    @per_page = APP_CONFIG[:latest_stories_items_per_page]
    APP_CONFIG[:latest_stories_items_per_page] = 4 if @section == Section::news
  end
  
  def reset_news_section_items_per_page
    APP_CONFIG[:latest_stories_items_per_page] = @per_page
  end
  
end