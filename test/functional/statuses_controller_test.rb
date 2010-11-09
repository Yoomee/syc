require File.dirname(__FILE__) + '/../test_helper'
class StatusesControllerTest < ActionController::TestCase

  should_have_member_only_actions :create
  should_have_owner_only_actions :destroy
  
  context "show action" do
    setup do
      @status = Factory.create(:status)
    end
    
    should "render show template" do
      get :show, :id => @status
      assert_template 'show'
    end
  end
  
  context "destroy action" do
    setup do
      stub_access
      @status = Factory.create(:status)
    end
    
    should "destroy model" do
      delete :destroy, :id => @status
      assert !Status.exists?(@status.id)
    end    
  end
end
