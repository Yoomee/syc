HomeController.class_eval do
  
  def index
    @news = Section.news.pages.published.sort_by(&:publish_on).reverse.first(3)
  end
  
end