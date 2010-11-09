class Object
  
  def in?(collection)
    collection.include?(self)
  end
  
  def metaclass
    class << self
      self
    end
  end
  
end