Section.class_eval do
  
  class << self
    
    def are_you
      Section.find_by_name('Are you...')
    end
  
    def ypp
      Section.find_by_name("YPP")
    end
  
  end

end