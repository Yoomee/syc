HomeController.class_eval do
  
  def index
    @news = Section.news.pages.latest.limit(3)
  end
  
end