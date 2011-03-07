require File.dirname(__FILE__) + '/../test_helper'
class MembersControllerTest < ActionController::TestCase
  
  should_have_member_only_action :show
  should_have_owner_only_actions :edit, :update
  
  context "on GET to show" do
    
    setup do
      @controller.stubs(:gate_keep).returns true
      @member = Factory.build(:member, :id => 123)
      Member.expects(:find).with('123').returns @member
      get :show, :id => 123
    end
    
    should assign_to(:member).with {@member}
    should render_template :show
    
  end
  
  
end