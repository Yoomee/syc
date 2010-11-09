class Array
  
  def move(from, to)
    insert(to, delete_at(from))
  end

  def move_by_name(name, to)
    return self if index(name).nil?
    move(index(name), to)
  end
  
  def move_to_front(name)
    move_by_name(name, 0)
  end
  
end