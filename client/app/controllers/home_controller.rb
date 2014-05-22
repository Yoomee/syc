HomeController.class_eval do
  
  def index
    @news = Page.find(:all, :conditions => {:section_id => Section.news.id}, :limit => 3, :order => 'publish_on DESC')
  end
  
end