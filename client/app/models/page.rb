Page.class_eval do

  class << self
    
    def about_us
      Page.find_by_title('About us')
    end
    
  end
  
  def staff_members?
    [10,18].include?(id)
  end

end
