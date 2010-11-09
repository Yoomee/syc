require File.dirname(__FILE__) + '/../../test_helper'
require 'action_view/test_case'
class SessionsHelperTest < ActionView::TestCase
  
  context "on call to logged_in?" do
    
    should "return false if not logged in" do
      assert !logged_in?
    end
    
    should "return true if logged in" do
      @logged_in_member = Factory.build(:member)
      assert logged_in?
    end
    
  end
  
end
