Mocha::ObjectMethods.module_eval do
  
  def stubs_pagination
    stubs(:total_pages).returns 5
    stubs(:current_page).returns 1
    stubs(:previous_page).returns nil
    stubs(:next_page).returns 2
  end
  
end