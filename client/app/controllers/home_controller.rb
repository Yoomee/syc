HomeController.class_eval do
  
  def index
    @news = Section.news.pages.latest.limit(3)
  end
  
  def test_500
    asdasd
  end
  
end