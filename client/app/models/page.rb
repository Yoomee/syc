Page.class_eval do

  class << self
    
    def about_us
      Page.find_by_title('About us')
    end
    
  end

end
