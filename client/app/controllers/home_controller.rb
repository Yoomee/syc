HomeController.class_eval do
  
  def index
    @news = Section.news.pages.published.latest.limit(3)
  end
  
end