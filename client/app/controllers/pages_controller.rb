PagesController.class_eval do
  
  before_filter :get_other_stuff, :only => %w{show}  
  
  private
  def get_other_stuff
    @other_stuff = Page.all.last(3)
  end
  
end